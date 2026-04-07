# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260407133821
# Script Filename: MMS-InstallScripts.rsc
# Stored Script Name: MMS-InstallScripts
# Description: Used to install and update management scripts and schedule them.
# Author: Kenneth G. Tipton
# Date: 2026-04-07
# Time: 13:38:21
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    :log info "Install/Update self-contained MMS dependencies for MMS-InitializeVariables"

    :local secretName "MikrotikScripts"
    :local secretId [/ppp secret find name=$secretName]
    :if ([:len $secretId] = 0) do={
        :log error "MMS-InstallScripts: PPP secret MikrotikScripts was not found."
        :error "Missing PPP secret MikrotikScripts"
    }

    :local secretValue [/ppp secret get $secretId password]
    :local ftpServer "srv010010037045.generationsgaither.com"

    # Required script files for MMS-InitializeVariables flow.
    :local requiredScriptFiles {
        "MMS-downloadFileFromFTP.rsc";
        "MMS-getFtpServerNameFromPPP.rsc";
        "MMS-removeFile.rsc";
        "MMS-dataSetMapSync.rsc";
        "MMS-InitializeVariables.rsc"
    }

    # Required dataset map files imported by MMS-InitializeVariables.
    :local requiredDataSetFiles {
        "dataSetMapDeviceType.rsc";
        "dataSetMapLocationBaseSubnetCidr.rsc";
        "dataSetMapDeviceLocationAtSite.rsc"
    }

    :local fetchFile do={
        :local remotePath $1
        :local localPath $2
        :do {
            /tool fetch address=$ftpServer src-path=$remotePath user=$secretName mode=ftp password=$secretValue dst-path=$localPath
            :return true
        } on-error={
            :log error ("MMS-InstallScripts: fetch failed for " . $remotePath . " -> " . $localPath)
            :return false
        }
    }

    :local installOrUpdateScript do={
        :local scriptFileName $1
        :if ([:len [/file find where name=$scriptFileName]] = 0) do={
            :log error ("MMS-InstallScripts: local script file not found: " . $scriptFileName)
            :return false
        }

        :local storedScriptName [:pick $scriptFileName 0 ([:len $scriptFileName] - 4)]
        :local sourceContent [/file get $scriptFileName contents]

        :if ([ :len [ /system/script/find where name=$storedScriptName ] ] = 0) do={
            /system script add name=$storedScriptName owner=admin source=$sourceContent
            :log info ("MMS-InstallScripts: created script " . $storedScriptName)
        } else={
            /system script set [find where name=$storedScriptName] source=$sourceContent
            :log info ("MMS-InstallScripts: updated script " . $storedScriptName)
        }

        :return true
    }

    # Ensure local dataSets directory exists.
    :do {
        /file make-directory name="dataSets"
    } on-error={
    }

    # Remove stale local files for a clean fetch.
    :foreach scriptFileName in=$requiredScriptFiles do={
        :foreach fileId in=[/file find where name=$scriptFileName] do={
            /file remove $fileId
        }
    }
    :foreach dataSetFileName in=$requiredDataSetFiles do={
        :local dataSetLocalPath ("dataSets/" . $dataSetFileName)
        :foreach fileId in=[/file find where name=$dataSetLocalPath] do={
            /file remove $fileId
        }
    }

    # Fetch and install required function scripts.
    :local scriptFetchFailures 0
    :foreach scriptFileName in=$requiredScriptFiles do={
        :local remoteScriptPath ("/MMS-Functions/" . $scriptFileName)
        :if ([$fetchFile $remoteScriptPath $scriptFileName] = false) do={
            :set scriptFetchFailures ($scriptFetchFailures + 1)
        }
    }

    :if ($scriptFetchFailures > 0) do={
        :log error ("MMS-InstallScripts: script fetch failures=" . $scriptFetchFailures)
        :error "Failed to fetch one or more required MMS scripts"
    }

    :local scriptInstallFailures 0
    :foreach scriptFileName in=$requiredScriptFiles do={
        :if ([$installOrUpdateScript $scriptFileName] = false) do={
            :set scriptInstallFailures ($scriptInstallFailures + 1)
        }
    }

    :if ($scriptInstallFailures > 0) do={
        :log error ("MMS-InstallScripts: script install failures=" . $scriptInstallFailures)
        :error "Failed to install one or more required MMS scripts"
    }

    # Fetch required dataset maps for MMS-InitializeVariables imports.
    :local dataSetFetchFailures 0
    :foreach dataSetFileName in=$requiredDataSetFiles do={
        :local remoteDataSetPath ("/dataSetMaps/" . $dataSetFileName)
        :local localDataSetPath ("dataSets/" . $dataSetFileName)
        :if ([$fetchFile $remoteDataSetPath $localDataSetPath] = false) do={
            :set dataSetFetchFailures ($dataSetFetchFailures + 1)
        }
    }

    :if ($dataSetFetchFailures > 0) do={
        :log error ("MMS-InstallScripts: dataset fetch failures=" . $dataSetFetchFailures)
        :error "Failed to fetch one or more required dataset map files"
    }

    :log info "MMS-InstallScripts: self-contained dependency install completed successfully."
}
