# MikroTik Management Scripts
# MMS Version: 0.01 Testing

{
    # setup Variables and lookup maps
    :global hostName

    :local deviceTypeMap {
        "acp"="ACCESS_POINT";
        "rtr"="ROUTER";
        "wrt"="WIRELESS_ROUTER";
        "swh"="SWITCH"
    }
    :local locationBaseMap {
        "37"="GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET";
        "40"="GGI.TN.COOKEVILLE.FACILITY.LOGAN_HOUSE";
        "41"="GGI.TN.WOODBURY.CAMPUS-AUBURNTOWN_ROAD.WARREN_HOUSE";
        "42"="GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET.ADMINISTRATION_BUILDING_II";
        "43"="GGI.TN.SPENCER.FACILITY.GENERATIONS_OF_SPENCER";
        "44"="GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET.ROBERT_COY_HOUSE";
        "45"="GGI.TN";
        "46"="GGI.TN";
        "47"="GGI.TN.COOKEVILLE.FACILITY.MENTAL_HEALTH_CENTER";
        "48"="GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD.KOLTON_WAYNE_HOUSE";
        "49"="GGI.TN.DRESDEN.FACILITY.MENTAL_HEALTH_CENTER";
        "50"="GGI.TN.MORRISON.FACILITY.MENTAL_HEALTH_CENTER";
        "51"="GGI.TN.COOKEVILLE.FACILITY.SKYLAR_HOUSE";
        "52"="GGI.TN.DRESDEN.OFFICE.CARE_MANAGERS_OFFICE";
        "53"="GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD.CAMPBELL_LODGE";
        "54"="GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD.ELLA_KATELYN_HOUSE";
        "55"="GGI.TN";
        "56"="GGI.TN.WOODBURY.CAMPUS-AUBURNTOWN_ROAD.HARWELL_HOUSE";
        "57"="GGI.TN.MCMINNVILLE.FACILITY.WOODLEE_TRAIL_HOUSE";
        "58"="GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD.KRISTOPHER_WYANE_HOUSE";
        "59"="GGI.TN.DAYTON.FACILITY.MENTAL_HEALTH_CENTER";
        "60"="GGI.TN.MORRISON.CAMPUS-SUNY_ACRES_ROAD.DENTON_HOUSE";
        "61"="GGI.TN.MORRISON.CAMPUS-SUNY_ACRES_ROAD.JAME_GILBERT_HOUSE";
        "62"="GGI.TN.MORRISON.CAMPUS-SUNY_ACRES_ROAD.WOOD_HOUSE";
        "63"="GGI.TN";
        "64"="GGI.TN.BAXTER.HOME_OFFICE.SHELIA_PALMER";
        "65"="GGI.TN.MCMINNVILLE.HOME_OFFICE.ANGILA_REDWINE";
        "66"="GGI.TN.MCMINNVILLE.HOME_OFFICE.WAYNE_GREER";
        "67"="GGI.KY.MIDDLESBORO.FACILITY.GENERATIONS_OF_MIDDLESBORO";
        "68"="GGI.TN.MCMINNVILLE.HOME_OFFICE.BUFFY_GAITHER";
        "69"="GGI.TN.MCMINNVILLE.HOME_OFFICE.TRESIA_CRIPPS";
        "190"="MTPC.TN.COOKEVILLE.OFFICE.CORPORATE";
        "200"="TNC.TN.MCMINNVILLE.HOME_OFFICE.KENNETH_TIPTON_I";
        "201"="TNC.TN.MCMINNVILLE.HOME_OFFICE.KENNETH_TIPTON_II"
    }
    :local locationTypeMap {
        "37"="CAMPUS";
        "40"="FACILITY";
        "41"="CAMPUS";
        "42"="CAMPUS";
        "43"="FACILITY";
        "44"="CAMPUS";
        "45"="UNKNOWN";
        "46"="UNKNOWN";
        "47"="FACILITY";
        "48"="CAMPUS";
        "49"="FACILITY";
        "50"="FACILITY";
        "51"="FACILITY";
        "52"="OFFICE";
        "53"="CAMPUS";
        "54"="CAMPUS";
        "55"="UNKNOWN";
        "56"="CAMPUS";
        "57"="FACILITY";
        "58"="CAMPUS";
        "59"="FACILITY";
        "60"="CAMPUS";
        "61"="CAMPUS";
        "62"="CAMPUS";
        "63"="UNKNOWN";
        "64"="HOME_OFFICE";
        "65"="HOME_OFFICE";
        "66"="HOME_OFFICE";
        "67"="FACILITY";
        "68"="HOME_OFFICE";
        "69"="HOME_OFFICE";
        "190"="OFFICE";
        "200"="HOME_OFFICE";
        "201"="HOME_OFFICE"
    }
    :local multiBuildingLocationMap {
        "37"="true";
        "38"="false";
        "39"="false";
        "40"="false";
        "41"="false";
        "42"="false";
        "43"="false";
        "44"="false";
        "45"="false";
        "46"="false";
        "47"="false";
        "48"="false";
        "49"="false";
        "50"="false";
        "51"="false";
        "52"="false";
        "53"="false";
        "54"="false";
        "55"="false";
        "56"="false";
        "57"="false";
        "58"="false";
        "59"="false";
        "60"="false";
        "61"="false";
        "62"="false";
        "63"="false";
        "64"="false";
        "65"="false";
        "66"="false";
        "67"="false";
        "68"="false";
        "69"="false";
        "190"="false";
        "200"="false";
        "201"="false"
    }
    :local wirelesSecurityProfiles {
        "GGT037"="EtdY37A6";
        "GGT038"="Lq8N2HPa";
        "GGT039"="EoD98kSK";
        "GGT040"="PjH83HSC";
        "GGT041"="Vm7AQ2Ld";
        "GGT042"="R4tHZ8Mn";
        "GGT043"="Ck9SWp52";
        "GGT044"="Hs3AJq8T";
        "GGT045"="Nf6HRx4B";
        "GGT046"="Td8SLm2Q";
        "GGT047"="Yp4AVc7K";
        "GGT048"="Mb2HHs9R";
        "GGT049"="Qx7SDn5J";
        "GGT050"="Gj8APf3W";
        "GGT051"="Kr5HTy6M";
        "GGT052"="Lc9SBb4N";
        "GGT053"="Za3AXm8P";
        "GGT054"="Wu6HQe2H";
        "GGT055"="Dn4SJr7C";
        "GGT056"="Fb8ANk5S";
        "GGT057"="Hp2HZv9L";
        "GGT058"="Mt7SQg4D";
        "GGT059"="Rx5ACc8V";
        "GGT060"="Js9HLm3A";
        "GGT061"="Pk4STw6E";
        "GGT062"="By7AHd2U";
        "GGT063"="Ne3HQk8G";
        "GGT064"="Uf6SRp5X";
        "GGT065"="Cm8AZj4T";
        "GGT066"="Wx2HBn9F";
        "GGT067"="Hr7SLd3Y";
        "GGT068"="Qg5AVs8K";
        "GGT069"="Ta4HMf6R";
        "GGT190"="Yk9SCp2W";
        "GGT200"="Rb6AHx7N";
        "GGT201"="Sd3HJv8Q";
        "GGR037"="EtdY37A6";
        "GGR038"="Lq8N2HPa";
        "GGR039"="EoD98kSK";
        "GGR040"="PjH83HSC";
        "GGR041"="Vm7AQ2Ld";
        "GGR042"="R4tHZ8Mn";
        "GGR043"="Ck9SWp52";
        "GGR044"="Hs3AJq8T";
        "GGR045"="Nf6HRx4B";
        "GGR046"="Td8SLm2Q";
        "GGR047"="Yp4AVc7K";
        "GGR048"="Mb2HHs9R";
        "GGR049"="Qx7SDn5J";
        "GGR050"="Gj8APf3W";
        "GGR051"="Kr5HTy6M";
        "GGR052"="Lc9SBb4N";
        "GGR053"="Za3AXm8P";
        "GGR054"="Wu6HQe2H";
        "GGR055"="Dn4SJr7C";
        "GGR056"="Fb8ANk5S";
        "GGR057"="Hp2HZv9L";
        "GGR058"="Mt7SQg4D";
        "GGR059"="Rx5ACc8V";
        "GGR060"="Js9HLm3A";
        "GGR061"="Pk4STw6E";
        "GGR062"="By7AHd2U";
        "GGR063"="Ne3HQk8G";
        "GGR064"="Uf6SRp5X";
        "GGR065"="Cm8AZj4T";
        "GGR066"="Wx2HBn9F";
        "GGR067"="Hr7SLd3Y";
        "GGR068"="Qg5AVs8K";
        "GGR069"="Ta4HMf6R";
        "GGR190"="Yk9SCp2W";
        "GGR200"="Rb6AHx7N";
        "GGR201"="Sd3HJv8Q";
        "GGM"="Maintenanc30nly.";
        "GGI"="4GGIaccess."
    }

    :local enforceIdentity15 do={
        :local identity [/system identity get name]

        :while ([:len $identity] != 15) do={
            :put "Current device identity: $identity"
            :put "Identity must be exactly 15 characters."
            :put "Enter a 15 character identity: "
            :set identity [/terminal/ask]
            :set identity [:pick $identity 0 15]
        }

        /system identity set name=$identity
        :set hostName $identity
        :put "hostName set to: $hostName"
    }

    :local getHostNamePortion do={
        :global hostName
        :local startIndex $1
        :local endIndex $2
        :local asNumber $3
        :local hostLen [:len $hostName]

        :if ($startIndex < 0 || $endIndex > $hostLen || $startIndex >= $endIndex) do={
            :error "Invalid start/end index for hostName"
        }

        :local portion [:pick $hostName $startIndex $endIndex]

        :if ($asNumber = true) do={
            :local numericPortion [:tonum $portion]
            :if ([:typeof $numericPortion] = "nil") do={
                :error "Selected hostname portion is not numeric"
            }
            :return $numericPortion
        }

        :return $portion
    }

    :local getSiteNumber do={
        :global hostName
        :local hostLen [:len $hostName]

        :if ($hostLen < 12) do={
            :error "hostName is too short to contain a site number"
        }

        :return [:pick $hostName 9 12]
    }

    :local getSiteNumberAsInteger do={
        :global hostName
        :local hostLen [:len $hostName]

        :if ($hostLen < 12) do={
            :error "hostName is too short to contain a site number"
        }

        :local numericSiteNumber [:tonum [:pick $hostName 9 12]]

        :if ([:typeof $numericSiteNumber] = "nil") do={
            :error "Site number portion is not numeric"
        }

        :return $numericSiteNumber
    }

    :local normalizeSegment do={
        :local value [:tostr $1]
        :local lowerCaseLetters {"a";"b";"c";"d";"e";"f";"g";"h";"i";"j";"k";"l";"m";"n";"o";"p";"q";"r";"s";"t";"u";"v";"w";"x";"y";"z"}
        :local upperCaseLetters {"A";"B";"C";"D";"E";"F";"G";"H";"I";"J";"K";"L";"M";"N";"O";"P";"Q";"R";"S";"T";"U";"V";"W";"X";"Y";"Z"}
        :local normalizedValue ""
        :local charIndex 0

        :while ($charIndex < [:len $value]) do={
            :local currentCharacter [:pick $value $charIndex ($charIndex + 1)]
            :local replacedCharacter false

            :if ($currentCharacter = " ") do={
                :set normalizedValue ($normalizedValue . "_")
                :set replacedCharacter true
            }

            :if ($replacedCharacter = false) do={
                :local letterIndex 0

                :while ($letterIndex < 26) do={
                    :if ($currentCharacter = ($lowerCaseLetters->$letterIndex)) do={
                        :set normalizedValue ($normalizedValue . ($upperCaseLetters->$letterIndex))
                        :set replacedCharacter true
                        :set letterIndex 26
                    }

                    :set letterIndex ($letterIndex + 1)
                }
            }

            :if ($replacedCharacter = false) do={
                :set normalizedValue ($normalizedValue . $currentCharacter)
            }

            :set charIndex ($charIndex + 1)
        }

        :return $normalizedValue
    }

    :local promptRequiredSegment do={
        :local promptText $1
        :local response ""

        :while ([:len $response] = 0) do={
            :put $promptText
            :set response [/terminal/ask]
        }

        :return $response
    }

    :local promptOptionalSegment do={
        :local promptText $1
        :put $promptText
        :local response [/terminal/ask]
        :return $response
    }

    :local getDeviceTypeName do={
        :local deviceTypeLookupMap $1
        :local abbrev $2

        :if ([:typeof ($deviceTypeLookupMap->$abbrev)] = "nil") do={
            :error ("Unknown device abbreviation: " . $abbrev)
        }

        :return ($deviceTypeLookupMap->$abbrev)
    }

    :local ensureGHASecurityProfile do={
        :local ghaProfileId [/interface wireless security-profiles find where name="GHA"]

        :if ([:len $ghaProfileId] = 0) do={
            /interface wireless security-profiles add authentication-types=wpa-eap,wpa2-eap comment="GGI.ALL.ALL.ALL.ALL.ALL.ACCESS_POINT.ALL.WIFI_SECURITY_PROFILE_EMPLOYEES" eap-methods=passthrough mode=dynamic-keys name="GHA" supplicant-identity="" tls-certificate=none tls-mode=dont-verify-certificate
        } else={
            /interface wireless security-profiles set $ghaProfileId authentication-types=wpa-eap,wpa2-eap comment="GGI.ALL.ALL.ALL.ALL.ALL.ACCESS_POINT.ALL.WIFI_SECURITY_PROFILE_EMPLOYEES" eap-methods=passthrough mode=dynamic-keys name="GHA" supplicant-identity="" tls-certificate=none tls-mode=dont-verify-certificate
        }
    }

    :local ensureWPAPSKSecurityProfile do={
        :local profileName [:tostr $1]
        :local profilePassword [:tostr $2]
        :local profileComment [:tostr $3]
        :local profileId [/interface wireless security-profiles find where name=$profileName]

        :if ([:len $profileName] = 0) do={
            :error "Wireless security profile name is required"
        }

        :if ([:len $profilePassword] = 0) do={
            :error "Wireless security profile password is required"
        }

        :if ([:len $profileId] = 0) do={
                /interface wireless security-profiles add authentication-types=wpa-psk,wpa2-psk comment=$profileComment name=$profileName mode=dynamic-keys unicast-ciphers=aes-ccm group-ciphers=aes-ccm wpa-pre-shared-key=$profilePassword wpa2-pre-shared-key=$profilePassword
        } else={
                /interface wireless security-profiles set $profileId authentication-types=wpa-psk,wpa2-psk comment=$profileComment name=$profileName mode=dynamic-keys unicast-ciphers=aes-ccm group-ciphers=aes-ccm wpa-pre-shared-key=$profilePassword wpa2-pre-shared-key=$profilePassword
        }
    }

    :local getWirelessSecurityProfilePassword do={
        :local securityProfileLookupMap $1
        :local profileName [:tostr $2]

        :if ([:typeof ($securityProfileLookupMap->$profileName)] = "nil") do={
            :error ("Missing wireless security profile password for " . $profileName)
        }

        :return ($securityProfileLookupMap->$profileName)
    }

    :local getWirelessSecurityProfileComment do={
        :local profileName [:tostr $1]
        :local locationName [:tostr $2]
        :local profileType "PSK"

        :if ([:len $profileName] = 0) do={
            :error "Wireless security profile name is required for comment creation"
        }

        :if ([:len $locationName] = 0) do={
            :error "Location name is required for comment creation"
        }

        :if ([:pick $profileName 0 3] = "GGT") do={
            :set profileType "TECHNICIANS"
        }

        :if ([:pick $profileName 0 3] = "GGR") do={
            :set profileType "RESIDENT"
        }

        :if ($profileName = "GGM") do={
            :set profileType "MAINTENANCE"
        }

        :if ($profileName = "GGI") do={
            :set profileType "INFO_SYSTEMS"
        }

        :if ($profileName = "GHA") do={
            :set profileType "ACTIVE_DIRECTORY_EMPLOYEES"
        }

        :return ($locationName . ".WIFI_SECURITY_PROFILE." . $profileType . "." . $profileName)
    }

    :local getLocationInfo do={
        :local locationBaseLookupMap $1
        :local locationTypeLookupMap $2
        :local rawLocationNumber [:tostr $3]
        :local numericLocationNumber [:tonum $rawLocationNumber]
        :local locationNumber $rawLocationNumber

        :if ([:typeof $numericLocationNumber] != "nil") do={
            :set locationNumber [:tostr $numericLocationNumber]
        }

        :if ([:typeof ($locationBaseLookupMap->$locationNumber)] = "nil") do={
            :error ("Unknown LocationNumber: " . $locationNumber)
        }

        :if ([:typeof ($locationTypeLookupMap->$locationNumber)] = "nil") do={
            :error ("Unknown location type for LocationNumber: " . $locationNumber)
        }

        :local locationBase ($locationBaseLookupMap->$locationNumber)
        :local locationInfo $locationBase

        :return $locationInfo
    }

    :local getLocationHasMultipleBuildings do={
        :local multiBuildingLookupMap $1
        :local rawLocationNumber [:tostr $2]
        :local numericLocationNumber [:tonum $rawLocationNumber]
        :local locationNumber $rawLocationNumber

        :if ([:typeof $numericLocationNumber] != "nil") do={
            :set locationNumber [:tostr $numericLocationNumber]
        }

        :if ([:typeof ($multiBuildingLookupMap->$locationNumber)] = "nil") do={
            :error ("Unknown multi-building setting for LocationNumber: " . $locationNumber)
        }

        :return ($multiBuildingLookupMap->$locationNumber)
    }

    $enforceIdentity15
    :local deviceAbbrev [$getHostNamePortion 0 3 false]
    :put ("Device abbreviation: " . $deviceAbbrev)
    :local currentDeviceType [$getDeviceTypeName $deviceTypeMap $deviceAbbrev]
    :put ("Current device type: " . $currentDeviceType)
    :local hostLen [:len $hostName]
    :local hostSuffixStart ($hostLen - 3)
    :local hostSuffixNumber [$getHostNamePortion $hostSuffixStart $hostLen true]
    :local siteNumber [$getSiteNumber]
    :local siteNumberAsInteger [$getSiteNumberAsInteger]
    :global currentLocationInfo
    :set currentLocationInfo [$getLocationInfo $locationBaseMap $locationTypeMap $siteNumberAsInteger]
    :local locationHasMultipleBuildings [$getLocationHasMultipleBuildings $multiBuildingLocationMap $siteNumberAsInteger]

    :global buildingName
    :set buildingName ""

    :if ($locationHasMultipleBuildings = "true") do={
        :put ("Multi-building location detected: " . $currentLocationInfo)
        :while ([:len $buildingName] = 0) do={
            :put "Enter building name: "
            :set buildingName [/terminal/ask]
        }
        :set buildingName [$normalizeSegment $buildingName]
        :set currentLocationInfo ($currentLocationInfo . "." . $buildingName)
    }

    :local deviceRoom [$promptRequiredSegment "Enter device room: "]
    :local otherInformation [$promptOptionalSegment "Enter other information (optional): "]
    :local normalizedLocationInfo [$normalizeSegment $currentLocationInfo]
    :local normalizedDeviceRoom [$normalizeSegment $deviceRoom]
    :local normalizedDeviceType [$normalizeSegment $currentDeviceType]
    :local deviceIdentity [$normalizeSegment $hostName]
    :local normalizedOtherInformation [$normalizeSegment $otherInformation]
    :global deviceLocationName
    :set deviceLocationName ($normalizedLocationInfo . "." . $normalizedDeviceRoom . "." . $normalizedDeviceType . "." . $deviceIdentity)

    :if ([:len $normalizedOtherInformation] > 0) do={
        :set deviceLocationName ($deviceLocationName . "." . $normalizedOtherInformation)
    }

    :set deviceLocationName [$normalizeSegment $deviceLocationName]
    :put ("Device location name: " . $deviceLocationName)

    :if ($currentDeviceType = "ACCESS_POINT") do={
        :local techProfileName ("GGT" . $siteNumber)
        :local residentProfileName ("GGR" . $siteNumber)
        :local infoSystensProfileName "GGI"
        :local techProfilePassword [$getWirelessSecurityProfilePassword $wirelesSecurityProfiles $techProfileName]
        :local residentProfilePassword [$getWirelessSecurityProfilePassword $wirelesSecurityProfiles $residentProfileName]
        :local maintenanceProfilePassword [$getWirelessSecurityProfilePassword $wirelesSecurityProfiles "GGM"]
        :local infoSystensProfilePassword [$getWirelessSecurityProfilePassword $wirelesSecurityProfiles $infoSystensProfileName]
        :local techProfileComment [$getWirelessSecurityProfileComment $techProfileName $deviceLocationName]
        :local residentProfileComment [$getWirelessSecurityProfileComment $residentProfileName $deviceLocationName]
        :local maintenanceProfileComment [$getWirelessSecurityProfileComment "GGM" $deviceLocationName]
        :local infoSystensProfileComment [$getWirelessSecurityProfileComment $infoSystensProfileName $deviceLocationName]

        $ensureGHASecurityProfile
        [$ensureWPAPSKSecurityProfile $techProfileName $techProfilePassword $techProfileComment]
        [$ensureWPAPSKSecurityProfile $residentProfileName $residentProfilePassword $residentProfileComment]
        [$ensureWPAPSKSecurityProfile "GGM" $maintenanceProfilePassword $maintenanceProfileComment]
        [$ensureWPAPSKSecurityProfile $infoSystensProfileName $infoSystensProfilePassword $infoSystensProfileComment]
    }

    :put ("Device abbreviation: " . $deviceAbbrev)
    :put ("Current device type: " . $currentDeviceType)
    :put "Hostname last three digits as number: $hostSuffixNumber"
    :put "Site number: $siteNumber"
    :put "Site number as integer: $siteNumberAsInteger"
    :put ("Location info: " . $currentLocationInfo)
    :put ("Device location name: " . $deviceLocationName)
}
