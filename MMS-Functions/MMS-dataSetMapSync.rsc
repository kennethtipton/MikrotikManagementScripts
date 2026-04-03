# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260403154154
# Script Filename: MMS-dataSetMapSync.rsc
# Stored Script Name: MMS-dataSetMapSync
# Description: Downloads from ftp server the file dataSetMaps/dataSetMapFileManifest.rsc first, imports it, then downloads all dataSetMap files listed in it.
# Author: Kenneth G. Tipton
# Date: 2026-04-03
# Time: 15:41:54
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    # Set to true to suppress screen output; set to false to enable verbose screen output.
    :local silent true

    ## Usage: :global listPPPSecrets; $listPPPSecrets "optionalName"

    :global listPPPSecrets do={
        :local filterName "mikrotikscripts"
        :if ([:len $1] > 0) do={
            :set filterName $1
        }

        :foreach s in=[/ppp secret find] do={
            :local name [/ppp secret get $s name]
            :if ([:len $filterName] = 0 || $name = $filterName) do={
                :local comment [/ppp secret get $s comment]
                :local password [/ppp secret get $s password]
                :put ("$name\t$comment\t$password")
            }
        }
    }

    # Function: downloadDataSetMaps
    # Syncs dataSetMapFileManifest.rsc from FTP first, imports it to populate the
    # dataSetMapFileManifest array (FILE001, FILE002...), then downloads all listed files.
    # All files are stored in the dataSets/ subfolder on the device.

    :global downloadDataSetMaps do={
        :local user "mikrotikscripts"
        :if ([:len $1] > 0) do={
            :set user $1
        }
        :local foundId [/ppp secret find name=$user]
        :if ([:len $foundId] = 0) do={
            :log error ("downloadDataSetMaps: PPP secret '" . $user . "' not found.")
            :if (!$silent) do={ :put ("ERROR: PPP secret '" . $user . "' not found.") }
            :error "PPP secret not found"
        }
        :local id [:pick $foundId 0]
        :local server [/ppp secret get $id comment]
        :local password [/ppp secret get $id password]
        :local remotePath "dataSetMaps/"
        :local localPath "dataSets/"
        :local manifestFile "dataSetMapFileManifest.rsc"
        :local localManifest ($localPath . $manifestFile)

        :if (!$silent) do={ :put ("Starting downloadDataSetMaps for user '" . $user . "' from server '" . $server . "'.") }

        # --- Ensure dataSets/ folder exists on device ---
        :if ([:len [/file find name="dataSets"]] = 0) do={
            :do {
                /file add name="dataSets" type=directory
            } on-error={
                :log warning ("downloadDataSetMaps: Could not create dataSets/ folder - it may already exist.")
            }
        }

        # --- Step 1: Always sync the manifest file first ---
        :if ([:len [/file find name=$localManifest]] > 0) do={
            :if (!$silent) do={ :put ("Deleting existing manifest: " . $localManifest) }
            /file remove [find name=$localManifest]
        }
        :if (!$silent) do={ :put ("Fetching manifest from server...") }
        :do {
            /tool fetch \
                address=$server \
                user=$user \
                password=$password \
                src-path=("/" . $remotePath . $manifestFile) \
                dst-path=$localManifest \
                mode=ftp \
                keep-result=yes
            :log info ("downloadDataSetMaps: Fetched manifest: " . $localManifest)
            :if (!$silent) do={ :put ("SUCCESS: Fetched manifest: " . $localManifest) }
        } on-error={
            :log error ("downloadDataSetMaps: ERROR: Failed to fetch manifest.")
            :if (!$silent) do={ :put ("ERROR: Failed to fetch manifest.") }
            :error "Failed to fetch dataSetMapFileManifest.txt"
        }

        # --- Step 2: Import manifest RSC to populate dataSetMapFileManifest array ---
        :do {
            /import file-name=$localManifest
        } on-error={
            :log error ("downloadDataSetMaps: ERROR: Failed to import manifest.")
            :if (!$silent) do={ :put ("ERROR: Failed to import manifest.") }
            :error "Failed to import dataSetMapFileManifest.rsc"
        }
        :global dataSetMapFileManifest

        # --- Step 3: Delete existing local dataSetMap files ---
        :foreach fileName in=$dataSetMapFileManifest do={
            :local localFile ($localPath . $fileName)
            :if ([:len [/file find name=$localFile]] > 0) do={
                :log info ("downloadDataSetMaps: Deleting existing file: " . $localFile)
                :if (!$silent) do={ :put ("Deleting existing file: " . $localFile) }
                /file remove [find name=$localFile]
            }
        }

        # --- Step 4: Download each dataSetMap file from FTP ---
        :local fileCount 0
        :foreach fileName in=$dataSetMapFileManifest do={
            :local localFile ($localPath . $fileName)
            :local srcPath ("/" . $remotePath . $fileName)
            :if (!$silent) do={ :put ("Downloading: " . $srcPath . " -> " . $localFile) }
            :do {
                /tool fetch \
                    address=$server \
                    user=$user \
                    password=$password \
                    src-path=$srcPath \
                    dst-path=$localFile \
                    mode=ftp \
                    keep-result=yes
                :set fileCount ($fileCount + 1)
                :log info ("downloadDataSetMaps: SUCCESS: " . $localFile)
                :if (!$silent) do={ :put ("SUCCESS: Downloaded: " . $localFile) }
            } on-error={
                :log error ("downloadDataSetMaps: ERROR: Failed to download: " . $srcPath)
                :if (!$silent) do={ :put ("ERROR: Failed to download: " . $srcPath) }
            }
        }

        :log info ("downloadDataSetMaps: Complete. " . $fileCount . " file(s) downloaded from server '" . $server . "'.")
        :if (!$silent) do={ :put ("downloadDataSetMaps: Complete. " . $fileCount . " file(s) downloaded.") }
    }
    $downloadDataSetMaps
}
