# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260405124938
# Script Filename: MMS-downloadFileFromFTP.rsc
# Stored Script Name: MMS-downloadFileFromFTP
# Description: Downloads a file from an FTP server using credentials stored in a PPP secret.
# Author: Kenneth G. Tipton
# Date: 2026-04-05
# Time: 12:49:38
# used AI tools: GitHub Copilot (GPT-5.4)
# ===================================================================
{
    # Usage:
    #   :global MMSdownloadFileFromFTP
    #   :local result [$MMSdownloadFileFromFTP "mikrotikscripts" "/dataSetMaps/dataSetMapFileManifest.rsc" "dataSets/dataSetMapFileManifest.rsc" true true]
    #
    # Parameter 1: PPP secret / FTP username (default: mikrotikscripts)
    # Parameter 2: remote FTP path (required)
    # Parameter 3: local destination path (required)
    # Parameter 4: remove existing local file first (optional, default: false)
    # Parameter 5: silent logging control (optional, default: true)

    :global MMSdownloadFileFromFTP do={
        :local ftpUser "mikrotikscripts"
        :local remotePath ""
        :local localPath ""
        :local removeExisting false
        :local silent true
        :local foundId ""
        :local secretId ""
        :local server ""
        :local password ""
        :local slashPos nil
        :local localFolder ""

        :if ([:len [:tostr $1]] > 0) do={
            :set ftpUser $1
        }
        :if ([:len [:tostr $2]] = 0) do={
            :log warning "MMSdownloadFileFromFTP: missing remote path parameter."
            :return "failed"
        }
        :set remotePath $2

        :if ([:len [:tostr $3]] = 0) do={
            :log warning "MMSdownloadFileFromFTP: missing local path parameter."
            :return "failed"
        }
        :set localPath $3

        :if ([:len [:tostr $4]] > 0) do={
            :set removeExisting $4
        }
        :if ([:len [:tostr $5]] > 0) do={
            :set silent $5
        }

        :set foundId [/ppp secret find name=$ftpUser]
        :if ([:len $foundId] = 0) do={
            :log warning ("MMSdownloadFileFromFTP: PPP secret '" . $ftpUser . "' not found.")
            :return "failed"
        }
        :set secretId [:pick $foundId 0]

        :do {
            :set server [/ppp secret get $secretId comment]
            :set password [/ppp secret get $secretId password]
        } on-error={
            :log warning ("MMSdownloadFileFromFTP: failed to read comment/password from PPP secret '" . $ftpUser . "'.")
            :return "failed"
        }

        :if ([:len $server] = 0 || [:len $password] = 0) do={
            :log warning ("MMSdownloadFileFromFTP: PPP secret '" . $ftpUser . "' is missing comment(server) or password.")
            :return "failed"
        }

        :set slashPos [:find $localPath "/"]
        :if ([:typeof $slashPos] != "nil") do={
            :set localFolder [:pick $localPath 0 $slashPos]
            :if ([:len $localFolder] > 0 && [:len [/file find name=$localFolder]] = 0) do={
                :do {
                    /file add name=$localFolder type=directory
                } on-error={
                }
            }
        }

        :if ($removeExisting = true && [:len [/file find name=$localPath]] > 0) do={
            /file remove [find name=$localPath]
            :if (!$silent) do={ :put ("Deleted existing local file: " . $localPath) }
        }

        :do {
            /tool fetch address=$server user=$ftpUser password=$password src-path=$remotePath dst-path=$localPath mode=ftp keep-result=yes
        } on-error={
            :log warning ("MMSdownloadFileFromFTP: failed to download " . $remotePath . " from " . $server)
            :return "failed"
        }

        :if ([:len [/file find name=$localPath]] = 0) do={
            :log warning ("MMSdownloadFileFromFTP: downloaded file not found at " . $localPath)
            :return "failed"
        }

        :if (!$silent) do={ :put ("Downloaded: " . $remotePath . " -> " . $localPath) }
        :return $localPath
    }
}
