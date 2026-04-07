# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260405124938
# Script Filename: MMS-addBkpPPPSecretFromDevicePasswordMap.rsc
# Stored Script Name: MMS-addBkpPPPSecretFromDevicePasswordMap
# Description: Downloads password map from FTP, adds/updates bkp<user> PPP secret for this device, then securely cleans up.
# Author: Kenneth G. Tipton
# Date: 2026-04-05
# Time: 12:49:38
# used AI tools: GitHub Copilot (GPT-5.4)
# ===================================================================
{
    # Usage examples:
    #   :global MMSaddBkpPPPSecretFromDevicePasswordMap
    #   $MMSaddBkpPPPSecretFromDevicePasswordMap "010010037045"
    #   $MMSaddBkpPPPSecretFromDevicePasswordMap "010010037045" "rtr010010037045"
    #
    # Parameter 1: required user suffix, resulting PPP secret name is bkp<user>
    # Parameter 2: optional device key override (default: /system identity name)

    :global MMSaddBkpPPPSecretFromDevicePasswordMap do={
        :local userSuffix ""
        :local deviceKey [/system identity get name]
        :local secretName ""
        :local password ""
        :local secretId ""
        :local ftpSecretName "mikrotikscripts"
        :local remoteMapPath "/dataSetMaps/dataSetMapDeviceBackupPassword.rsc"
        :local localFolder "dataSets"
        :local localMapPath ($localFolder . "/dataSetMapDeviceBackupPassword.rsc")
        :local returnValue "failed"
        :global MMSdownloadFileFromFTP

        :local cleanup do={
            :if ([:len [/file find name=$localMapPath]] > 0) do={
                /file remove [find name=$localMapPath]
            }
            :if ([:len [/system script environment find name="dataSetMapDeviceBackupPassword"]] > 0) do={
                /system script environment remove [find name="dataSetMapDeviceBackupPassword"]
            }
        }

        # Start clean in case a previous run left any local map file or environment variable behind.
        $cleanup

        :if ([:len $1] = 0) do={
            :log warning "MMSaddBkpPPPSecretFromDevicePasswordMap: missing required user suffix parameter."
            :return "failed"
        }
        :set userSuffix $1

        :if ([:len $2] > 0) do={
            :set deviceKey $2
        }

        :if ([:typeof $MMSdownloadFileFromFTP] = "nil") do={
            :log warning "MMSaddBkpPPPSecretFromDevicePasswordMap: MMSdownloadFileFromFTP is not loaded."
            :return "failed"
        }

        :if ([:len [/file find name=$localFolder]] = 0) do={
            :do {
                /file add name=$localFolder type=directory
            } on-error={}
        }

        :local downloadResult [$MMSdownloadFileFromFTP $ftpSecretName $remoteMapPath $localMapPath true true]
        :if ($downloadResult = "failed") do={
            :log warning ("MMSaddBkpPPPSecretFromDevicePasswordMap: failed to download " . $remoteMapPath)
            $cleanup
            :return "failed"
        }

        :do {
            /import file-name=$localMapPath
        } on-error={
            :log warning ("MMSaddBkpPPPSecretFromDevicePasswordMap: failed to import " . $localMapPath)
            $cleanup
            :return "failed"
        }

        :global dataSetMapDeviceBackupPassword
        :if ([:typeof $dataSetMapDeviceBackupPassword] != "array") do={
            :log warning "MMSaddBkpPPPSecretFromDevicePasswordMap: imported map variable is not available."
            $cleanup
            :return "failed"
        }

        :set password ($dataSetMapDeviceBackupPassword->$deviceKey)
        :if ([:len $password] = 0) do={
            :log warning ("MMSaddBkpPPPSecretFromDevicePasswordMap: no password map entry found for device key " . $deviceKey)
            $cleanup
            :return "failed"
        }

        :set secretName ("bkp" . $userSuffix)
        :set secretId [/ppp secret find where name=$secretName]

        :if ([:len $secretId] = 0) do={
            /ppp secret add name=$secretName password=$password comment=$deviceKey
            :log info ("MMSaddBkpPPPSecretFromDevicePasswordMap: added /ppp secret " . $secretName . " for device " . $deviceKey)
            :set returnValue $secretName
        } else={
            /ppp secret set $secretId password=$password comment=$deviceKey
            :log info ("MMSaddBkpPPPSecretFromDevicePasswordMap: updated /ppp secret " . $secretName . " for device " . $deviceKey)
            :set returnValue $secretName
        }

        $cleanup
        :return $returnValue
    }
}
