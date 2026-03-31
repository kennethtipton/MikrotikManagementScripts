    # Function - Create a bridge interface with name "BRDG-<Abbreviation>-<ip_address_12char>-<netbit_base10>"
    # Usage: :set $bridgeName [$createBridge $abbrev $deviceIpCidr]
    :local createBridge do={
        :local abbrev $1
        :local ipCidr $2
        :if ([:len $abbrev] = 0 || [:len $ipCidr] = 0) do={
            :return ""
        }
        :local parts [:toarray [:split $ipCidr "/"]]
        :local ip [:pick $parts 0]
        :local netbit [:pick $parts 1]
        :local octets [:toarray [:split $ip "."]]
        :local ip12 ([:pick ("00" . [:pick $octets 0]) ([:len [:pick $octets 0]]), 2] . [:pick ("00" . [:pick $octets 1]) ([:len [:pick $octets 1]]), 2] . [:pick ("00" . [:pick $octets 2]) ([:len [:pick $octets 2]]), 2] . [:pick ("00" . [:pick $octets 3]) ([:len [:pick $octets 3]]), 2])
        :set ip12 ($ip12)
        :local bridgeName ("BRDG-" . $abbrev . "-" . $ip12 . "-" . $netbit)
        /interface bridge add name=$bridgeName
        :return $bridgeName
    }

# Version: 202603282100
# Script Name: deviceinformation
# Script file created by Kenneth Tipton
# Telecommunications Networking and Computing, Inc.
#
# Provides device information functions: model, manufacturer, operating system, device serial number, hostname, device type, and IP address.
# example: :set $deviceModel [$getDeviceModel]
# example: :set $manufacturer [$getDeviceManufacturer]
# example: :set $os [$getOperatingSystem]
# example: :set $deviceSerialNumber [$getDeviceSerialNumber]
# note: $hostname and $deviceType are set as global variables by their respective functions
# note: $deviceIp and $deviceIpCidr are set as global variables by getIpFromHostname
{
    # Global variables
    :global hostname
    :global deviceType
    :global deviceIp
    :global deviceIpCidr
    :global deviceSerialNumber

    # =====================================================================
    # Dataset Maps
    # =====================================================================

    # =====================================================================
    # Permanent Global Variables Dataset Map
    # =====================================================================
    
    # This map lists variables that should always exist in /system script environment
    :global dataSetMap {
        "hostname"=true;
        "deviceType"=true;
        "deviceIp"=true;
        "deviceIpCidr"=true;
        "realLocation"=true;
        "baseSiteLocationNumber"=true;
        "baseLocation"=true;
        "manufacturer"=true;
        "deviceModel"=true;
        "operatingSystem"=true;
        "deviceSerialNumber"=true
    }

    # Device type lookup map - maps 3-letter hostname designator to device type
    :global deviceTypeMap
    :set deviceTypeMap {
        "acp"="ACCESS_POINT";
        "rtr"="ROUTER";
        "wrt"="WIRELESS_ROUTER";
        "swh"="SWITCH"
    }

        # Company abbreviation map for bridges
        :global companyAbbrevMap
        :set companyAbbrevMap {
            "GGI"="Generations Gaither Inc.";
            "GGR"="Generations Gaither Residents";
            "TNC"="Telecommunications Networking and Computing, Inc.";
            "MSPCI"="Midstate Termite and Pest Control, Inc.";
            "TLC"="Twin Lakes Communications";
            "GHA"="Generations Health Association, Inc.";
            "SPECTRUM"="Spectrum Business";
            "BTC"="Bledsoe Telephone Cooperative";
            "BLC"="BenLomand Communications"
        }


    # Location base map - maps site number (octet 3 of IP) to fully qualified location name
    :global locationBaseMap
    :set locationBaseMap {
        "037"="GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET";
        "040"="GGI.TN.COOKEVILLE.FACILITY.LOGAN_HOUSE";
        "041"="GGI.TN.WOODBURY.CAMPUS-AUBURNTOWN_ROAD.WARREN_HOUSE";
        "042"="GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET.ADMINISTRATION_BUILDING_II";
        "043"="GGI.TN.SPENCER.FACILITY.GENERATIONS_OF_SPENCER";
        "044"="GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET.ROBERT_COY_HOUSE";
        "047"="GGI.TN.COOKEVILLE.FACILITY.MENTAL_HEALTH_CENTER";
        "048"="GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD.KOLTON_WAYNE_HOUSE";
        "049"="GGI.TN.DRESDEN.FACILITY.MENTAL_HEALTH_CENTER";
        "050"="GGI.TN.MORRISON.FACILITY.MENTAL_HEALTH_CENTER";
        "051"="GGI.TN.COOKEVILLE.FACILITY.SKYLAR_HOUSE";
        "052"="GGI.TN.DRESDEN.OFFICE.CARE_MANAGERS_OFFICE";
        "053"="GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD.CAMPBELL_LODGE";
        "054"="GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD.ELLA_KATELYN_HOUSE";
        "056"="GGI.TN.WOODBURY.CAMPUS-AUBURNTOWN_ROAD.HARWELL_HOUSE";
        "057"="GGI.TN.MCMINNVILLE.FACILITY.WOODLEE_TRAIL_HOUSE";
        "058"="GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD.KRISTOPHER_WYANE_HOUSE";
        "059"="GGI.TN.DAYTON.FACILITY.MENTAL_HEALTH_CENTER";
        "060"="GGI.TN.MORRISON.CAMPUS-SUNY_ACRES_ROAD.DENTON_HOUSE";
        "061"="GGI.TN.MORRISON.CAMPUS-SUNY_ACRES_ROAD.JAME_GILBERT_HOUSE";
        "062"="GGI.TN.MORRISON.CAMPUS-SUNY_ACRES_ROAD.WOOD_HOUSE";
        "064"="GGI.TN.BAXTER.HOME_OFFICE.SHELIA_PALMER";
        "065"="GGI.TN.MCMINNVILLE.HOME_OFFICE.ANGILA_REDWINE";
        "066"="GGI.TN.MCMINNVILLE.HOME_OFFICE.WAYNE_GREER";
        "067"="GGI.KY.MIDDLESBORO.FACILITY.GENERATIONS_OF_MIDDLESBORO";
        "068"="GGI.TN.MCMINNVILLE.HOME_OFFICE.BUFFY_GAITHER";
        "069"="GGI.TN.MCMINNVILLE.HOME_OFFICE.TRESIA_CRIPPS";
        "190"="MTPC.TN.COOKEVILLE.OFFICE.CORPORATE";
        "200"="TNC.TN.MCMINNVILLE.HOME_OFFICE.KENNETH_TIPTON_I";
        "201"="TNC.TN.MCMINNVILLE.HOME_OFFICE.KENNETH_TIPTON_II"
    }

    # Multi-building location map - only includes site numbers with multiple buildings
    :global multiBuildingLocationMap
    :set multiBuildingLocationMap {
        "037"="true"
    }

    # =====================================================================
    # Functions
    # =====================================================================

    # Function - Get the real location string for the device
    # Sets and returns global variable $realLocation
    # If not a multi-building site: $realLocation = baseLocation.deviceLocation
    # If multi-building site: $realLocation = baseLocation.buildingName.deviceLocation
    # Usage: :set $loc [$getRealLocation $baseLocation $deviceLocation $buildingName $isMultiBuilding]
    :global realLocation
    :global getRealLocation do={
        :local baseLocation $1
        :local deviceLocation $2
        :local buildingName $3
        :local isMultiBuilding $4
        :global realLocation
        :if ($isMultiBuilding = "true") do={
            :set realLocation ($baseLocation . "." . $buildingName . "." . $deviceLocation)
        } else={
            :set realLocation ($baseLocation . "." . $deviceLocation)
        }
        :return $realLocation
    }

    # Function - Get the base site location number (characters 10,11,12 of hostname)
    # Usage: :set $siteNumber [$baseSiteLocationNumber]
    :global baseSiteLocationNumber do={
        :global hostname
        :local hn $hostname
        :if ([:len $hn] < 12) do={
            :return ""
        }
        :return [:pick $hn 9 12]
    }

    # Function - Get the base location for the device from the baseSiteLocationNumber and locationBaseMap
    # Usage: :set $baseLocation [$getDeviceBaseLocation]
    :global getDeviceBaseLocation do={
        :local siteNumberStr [$baseSiteLocationNumber]
        :if ([:len $siteNumberStr] = 0) do={
            :return ""
        }
        :local siteNumber ($siteNumberStr)
        :local baseLocation ($locationBaseMap->$siteNumber)
        :if ([:typeof $baseLocation] = "nil") do={
            :return ""
        }
        :return $baseLocation
    }

    # Function - Get location information from locationBaseMap
    # Usage: :set $info [$getLocationInfo $siteNumber]
    # Returns a map with keys: owner, state, city, locationType, type, buildingName (if present)
    :global getLocationInfo do={
        :local siteNumber $1
        :local entry ($locationBaseMap->$siteNumber)
        :if ([:typeof $entry] = "nil") do={
            :return ""
        }
        :local parts [:toarray [:split $entry "."]]
        :local owner ([:pick $parts 0])
        :local state ([:pick $parts 1])
        :local city ([:pick $parts 2])
        :local locationType ([:pick $parts 3])
        :local buildingName ""
        :if ([:len $parts] > 4) do={
            :set buildingName ([:pick $parts 4])
        }
        :local type "other"
        :if ([:typeof $locationType] != "nil" && [:find [:convert transform=lc $locationType] "campus"] = 0) do={
            :set type "CAMPUS"
        }
        :local result {
            "owner"=$owner;
            "state"=$state;
            "city"=$city;
            "locationType"=$locationType;
            "type"=$type;
            "buildingName"=$buildingName
        }
        :return $result
    }
    
    # Function - Replace spaces in a string with underscores
    # Usage: :set $result [$replaceSpacesWithUnderscore "your string here"]
    :global replaceSpacesWithUnderscore do={
        :local str $1
        :local result ""
        :for i from=0 to=([:len $str] - 1) do={
            :local ch [:pick $str $i ($i + 1)]
            :if ($ch = " ") do={
                :set result ($result . "_")
            } else={
                :set result ($result . $ch)
            }
        }
        :return $result
    }


    # Function - Convert a string to upper or lower case based on option
    # Usage: :set $result [$convertCase $string $caseOpt]
    # $caseOpt = "upper" or "lower" (case-insensitive)
    :global convertCase do={
        :local str $1
        :local opt [:convert transform=lc $2]
        :if ($opt = "upper") do={
            :return [:convert transform=uc $str]
        } else={
            :if ($opt = "lower") do={
                :return [:convert transform=lc $str]
            } else={
                :return $str
            }
        }
    }


    # Function - Prompt the user with a question and return their answer, with optional case conversion and space replacement
    # Usage: :set $answer [$getAnswer "Your question here" "upper" "noSpaces"]
    # $2 = "upper" or "lower" (optional, case-insensitive)
    # $3 = "noSpaces" (optional, replaces spaces with underscores)
    :local getAnswer do={
        :local question $1
        :local caseOpt ""
        :local noSpacesOpt ""
        :if ([:len $2] > 0) do={
            :set caseOpt $2
        }
        :if ([:len $3] > 0) do={
            :set noSpacesOpt $3
        }
        :local answer ""
        :while ([:len $answer] = 0) do={
            :put $question
            :set answer [/terminal/ask]
        }
        :if ([:len $caseOpt] > 0) do={
            :set answer [$convertCase $answer $caseOpt]
        }
        :if ($noSpacesOpt = "noSpaces") do={
            :set answer [$replaceSpacesWithUnderscore $answer]
        }
        :return $answer
    }

    # Function - Convert a string to all uppercase (legacy compatible)
    # Usage: :set $result [$toUpper "your string"]
    # $1 = string to convert
    :global toUpper do={ :return [:convert transform=uc $1] }

    # Function - Get the model of the device from system resource
    :local getDeviceModel do={
        :local model [/system resource get board-name]
        :return $model
    }

    # Function - Get the manufacturer of the device from system resource
    :local getDeviceManufacturer do={
        :local manufacturer [/system resource get platform]
        :return $manufacturer
    }

    # Function - Get the operating system version from system resource
    :local getOperatingSystem do={
        :local os [/system resource get version]
        :return $os
    }

    # Function - Get the unique device serial number from system routerboard
    :local getDeviceSerialNumber do={
        :local deviceSerialNumber [/system routerboard get serial-number]
        :return $deviceSerialNumber
    }

    # Function - Get the hostname (system identity) of the device and set as global
    :local getHostname do={
        :global hostname [/system identity get name]
        :return $hostname
    }

    # Function - Get the device type from the hostname designator using deviceTypeMap and set as global
    :local getDeviceType do={
        :local tempHostname [/system identity get name]
        :local abbrev [:pick $tempHostname 0 3]
        :global deviceType ($deviceTypeMap->$abbrev)
        :if ([:typeof $deviceType] = "nil") do={
            :set $deviceType "UNKNOWN"
        }
        :return $deviceType
    }

    # Function - Convert the hostname to an IP address and CIDR IP address
    # Hostname format: [devType][oct1][oct2][oct3][oct4][netbits]
    # Example: acp010010037007024 -> deviceIp=10.10.37.7  deviceIpCidr=10.10.37.7/24
    :local getIpFromHostname do={
        :global deviceIp
        :global deviceIpCidr
        :local hn [/system identity get name]
        :if ([:len $hn] < 18) do={
            :set deviceIp ""
            :set deviceIpCidr ""
            :return ""
        }
        :local a [:tonum [:pick $hn 3 6]]
        :local b [:tonum [:pick $hn 6 9]]
        :local c [:tonum [:pick $hn 9 12]]
        :local d [:tonum [:pick $hn 12 15]]
        :local netbits [:tonum [:pick $hn 15 18]]
        :set deviceIp ("$a.$b.$c.$d")
        :set deviceIpCidr ("$a.$b.$c.$d/$netbits")
        :return $deviceIpCidr
    }

        # Function - Get the network address in CIDR notation from $deviceIpCidr
        # Usage: :set $networkCidr [$getNetworkFromCidr $deviceIpCidr]
        :local getNetworkFromCidr do={
            :local ipCidr $1
            :if ([:len $ipCidr] = 0) do={
                :return ""
            }
            :local parts [:toarray [:split $ipCidr "/"]]
            :local ip [:pick $parts 0]
            :local prefix [:tonum [:pick $parts 1]]
            :local octets [:toarray [:split $ip "."]]
            :local a [:tonum [:pick $octets 0]]
            :local b [:tonum [:pick $octets 1]]
            :local c [:tonum [:pick $octets 2]]
            :local d [:tonum [:pick $octets 3]]
            :local mask (0xffffffff << (32 - $prefix))
            :local ipnum (($a << 24) + ($b << 16) + ($c << 8) + $d)
            :local netnum ($ipnum & $mask)
            :local netA (($netnum >> 24) & 0xff)
            :local netB (($netnum >> 16) & 0xff)
            :local netC (($netnum >> 8) & 0xff)
            :local netD ($netnum & 0xff)
            :return ("$netA.$netB.$netC.$netD/$prefix")
        }

    # =====================================================================
    # Additional Functions
    # =====================================================================

    # Function - Remove a global dataset variable by name
    # Usage: [$removeGlobalVariable "variableName"]
    :global removeGlobalVariable do={
        :local varName $1
        :if ([:len $varName] > 0) do={
            /system script environment remove [find name=$varName]
        }
    }

    # Function - Get the real location string for the device
    # Sets and returns global variable $realLocation
    # If not a multi-building site: $realLocation = baseLocation.deviceLocation
    # If multi-building site: $realLocation = baseLocation.buildingName.deviceLocation
    # Usage: :set $loc [$getRealLocation $baseLocation $deviceLocation $buildingName $isMultiBuilding]
    :global realLocation
    :global getRealLocation do={
        :local baseLocation $1
        :local deviceLocation $2
        :local buildingName $3
        :local isMultiBuilding $4
        :global realLocation
        :if ($isMultiBuilding = "true") do={
            :set realLocation ($baseLocation . "." . $buildingName . "." . $deviceLocation)
        } else={
            :set realLocation ($baseLocation . "." . $deviceLocation)
        }
        :return $realLocation
    }

    # =====================================================================
    # TEST - Call each function and display results
    # =====================================================================
    :put "===== deviceinformation Test ====="
    :put ("Device Model      : " . [$getDeviceModel])
    :put ("Manufacturer      : " . [$getDeviceManufacturer])
    :put ("Operating System  : " . [$getOperatingSystem])
    :put ("Device Serial #   : " . [$getDeviceSerialNumber])
    :put ("Hostname          : " . [$getHostname])
    :put ("Device Type       : " . [$getDeviceType])
    :put ("IP Address        : " . [$getIpFromHostname])
    :put "=================================="
    :put ("Global \$hostname    : " . $hostname)
    :put ("Global \$deviceType  : " . $deviceType)
    :put ("Global \$deviceIp    : " . $deviceIp)
    :put ("Global \$deviceIpCidr: " . $deviceIpCidr)
    :put ("
    Base Site Number   : " . [$baseSiteLocationNumber])
    :put ("Base Location      : " . [$getDeviceBaseLocation])
    :local siteNumberStr [$baseSiteLocationNumber]
    :global isMultiBuilding "false"
    :if ([:typeof ($multiBuildingLocationMap->$siteNumberStr)] != "nil" && ($multiBuildingLocationMap->$siteNumberStr) = "true") do={
        :set isMultiBuilding "true"
    }

    :if ($isMultiBuilding = "true") do={
        :local buildingName [$getAnswer "Enter the Building Name: "]
        :put ("getAnswer normal         : " . $buildingName)
        :put ("getAnswer upper          : " . [$convertCase $buildingName "upper"])
        :put ("getAnswer lower          : " . [$convertCase $buildingName "lower"])
        :put ("getAnswer noSpaces       : " . [$replaceSpacesWithUnderscore $buildingName])
        :put ("getAnswer upper+noSpaces : " . [$replaceSpacesWithUnderscore ([$convertCase $buildingName "upper"])])
    } else={
        :put "Site is not in multiBuildingLocationMap; skipping getAnswer prompt."
    }

    # Always ask for device location at site, regardless of multi-building status
    :local deviceLocation [$getAnswer "Enter device's location at this site:"]
    :put ("Device location at site  : " . $deviceLocation)
    # Test: Display the real location using getRealLocation
    :local baseLocation [$getDeviceBaseLocation]
    :local siteNumberStr [$baseSiteLocationNumber]
    :local realLoc [$getRealLocation $baseLocation $deviceLocation $buildingName $isMultiBuilding]
    # Use getAnswer logic to convert to uppercase and remove spaces (replace with underscores)
    :local realLocFormatted [$convertCase $realLoc "upper"]
    :set realLocFormatted [$replaceSpacesWithUnderscore $realLocFormatted]
    :put ("Real Location: " . $realLocFormatted)
    # Test: Remove global variable 'deviceType' and show result
    $removeGlobalVariable "deviceTypeMap"
    :put "===== Test Complete ====="    
}
