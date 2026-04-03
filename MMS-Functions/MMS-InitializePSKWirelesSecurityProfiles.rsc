# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260403154154
# Script Filename: MMS-InitializePSKWirelesSecurityProfiles.rsc
# Stored Script Name: MMS-InitializePSKWirelesSecurityProfiles
# Description: Creates PSK wireless security profiles for the current access point from the downloaded dataset map.
# Author: Kenneth G. Tipton
# Date: 2026-04-03
# Time: 15:41:54
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    # Set to true to suppress screen output; set to false for status output.
    :global silent false
    :global baseSiteLocationNumber
    :global MMSremoveFile
    :local pskMapFile "dataSets/dataSetMapPSKWirelessSecurityProfiles.rsc"

    :do {
        /system script run "MMS-removeFile"
    } on-error={
        :error "initializePSKWirelesSecurityProfiles: Failed to run MMS-removeFile"
    }

    :local removePSKMapFile do={
        :local hadFile ([:len [/file find name=$pskMapFile]] > 0)
        $MMSremoveFile $pskMapFile
        :if ($hadFile = true) do={
            :if ($silent = false) do={ :put ("Deleted local file: " . $pskMapFile) }
        }
    }

    :if ([:typeof $baseSiteLocationNumber] = "nil" || [:len [:tostr $baseSiteLocationNumber]] = 0) do={
        :do {
            /system script run "MMS-InitializeVariables"
        } on-error={
            :error "initializePSKWirelesSecurityProfiles: Failed to run initializeVariables"
        }
    }

    :if ([:typeof $baseSiteLocationNumber] = "nil" || [:len [:tostr $baseSiteLocationNumber]] = 0) do={
        :error "initializePSKWirelesSecurityProfiles: baseSiteLocationNumber is missing after initializeVariables"
    }

    # Ensure the local dataSets folder exists.
    :if ([:len [/file find name="dataSets"]] = 0) do={
        :do {
            /file add name="dataSets" type=directory
        } on-error={
        }
    }

    # Download the PSK dataset map from FTP each run because it contains clear-text passwords.
    :local ftpUser "mikrotikscripts"
    :local ftpSecretId [/ppp secret find name=$ftpUser]
    :if ([:len $ftpSecretId] = 0) do={
        $removePSKMapFile
        :error "initializePSKWirelesSecurityProfiles: PPP secret 'mikrotikscripts' not found"
    }
    :local sid [:pick $ftpSecretId 0]
    :local ftpServer [/ppp secret get $sid comment]
    :local ftpPassword [/ppp secret get $sid password]

    $removePSKMapFile

    :do {
        /tool fetch address=$ftpServer user=$ftpUser password=$ftpPassword src-path="/dataSetMaps/dataSetMapPSKWirelessSecurityProfiles.rsc" dst-path=$pskMapFile mode=ftp keep-result=yes
        :if ($silent = false) do={ :put ("Downloaded: " . $pskMapFile) }
    } on-error={
        :error "initializePSKWirelesSecurityProfiles: Failed to download dataSetMapPSKWirelessSecurityProfiles.rsc"
    }

    :if ([:len [/file find name=$pskMapFile]] = 0) do={
        :error "initializePSKWirelesSecurityProfiles: Downloaded PSK dataset file not found"
    }

    :do {
        /import file-name=$pskMapFile
        :if ($silent = false) do={ :put "Imported dataSetMapPSKWirelessSecurityProfiles" }
    } on-error={
        $removePSKMapFile
        :error "initializePSKWirelesSecurityProfiles: Failed to import dataSetMapPSKWirelessSecurityProfiles"
    }

    :global dataSetMapPSKWirelessSecurityProfiles

    :local hostname [/system identity get name]
    :local deviceTypeCode [:pick $hostname 0 3]

    # Only apply profile creation on access points.
    :if ($deviceTypeCode != "acp") do={
        :log info "initializePSKWirelesSecurityProfiles: Device is not an access point; no profiles created."
        :if ($silent = false) do={ :put "Device is not an access point; no profiles created." }
        $removePSKMapFile
        :return
    }

    :local siteNum [:tostr $baseSiteLocationNumber]

    :if ([:len $siteNum] = 0) do={
        $removePSKMapFile
        :error "initializePSKWirelesSecurityProfiles: baseSiteLocationNumber is required"
    }

    :local ensureWPAPSKSecurityProfile do={
        :local profileName [:tostr $1]
        :local profilePassword [:tostr $2]
        :local profileId [/interface wireless security-profiles find where name=$profileName]

        :if ([:len $profileName] = 0 || [:len $profilePassword] = 0) do={
            :return
        }

        :if ([:len $profileId] = 0) do={
            /interface wireless security-profiles add authentication-types=wpa-psk,wpa2-psk mode=dynamic-keys name=$profileName supplicant-identity="" unicast-ciphers=aes-ccm group-ciphers=aes-ccm wpa-pre-shared-key=$profilePassword wpa2-pre-shared-key=$profilePassword
            :if ($silent = false) do={ :put ("Added profile: " . $profileName) }
        } else={
            /interface wireless security-profiles set $profileId authentication-types=wpa-psk,wpa2-psk mode=dynamic-keys name=$profileName supplicant-identity="" unicast-ciphers=aes-ccm group-ciphers=aes-ccm wpa-pre-shared-key=$profilePassword wpa2-pre-shared-key=$profilePassword
            :if ($silent = false) do={ :put ("Updated profile: " . $profileName) }
        }
    }

    :foreach profileName,profilePassword in=$dataSetMapPSKWirelessSecurityProfiles do={
        :local profileLen [:len $profileName]

        # 3-character profile names apply to every access point.
        :if ($profileLen = 3) do={
            [$ensureWPAPSKSecurityProfile $profileName $profilePassword]
        }

        # 6-character names apply only when suffix matches baseSiteLocationNumber.
        :if ($profileLen = 6) do={
            :local profileSite [:pick $profileName 3 6]
            :if ($profileSite = $siteNum) do={
                [$ensureWPAPSKSecurityProfile $profileName $profilePassword]
            }
        }
    }

    # Delete local clear-text password dataset after use.
    $removePSKMapFile
}
