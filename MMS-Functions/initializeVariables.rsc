

# Script Name: initializeVariables.rsc
# Description: Initializes global variables commonly used in Mikrotik RouterOS scripts.
# Author: Kenneth G. Tipton
# Date: 2026-03-31

{
    # Data Mapping and Variable Initialization Script for Mikrotik RouterOS

    # ===============================
    # Import dataset maps from external files
    # ===============================
    /import file-name=dataSetMapDeviceType.rsc
    /import file-name=dataSetMapLocationBase.rsc
 
    # Functions to initialize global variables for device information and mappings.

    # Function - Read deviceLocationAtSite.txt if it exists and store contents in devicesSiteLocation
    # Sets global variable devicesSiteLocation to file contents or "" if not found
    :global devicesSiteLocation ""
    :local readDeviceLocationAtSiteFile do={
        :local fileName "deviceLocationAtSite.txt"
        :if ([/file find name=$fileName] != "") do={
            :global devicesSiteLocation [/file get $fileName contents]
        } else={
            :global devicesSiteLocation ""
        }
        :return $devicesSiteLocation
    }


    # Function - Get the base site location number from the hostname
    # The base site location number is the fourth set of three characters in the hostname
    # Returns the site number if found in locationBaseMap, else ""
    :local getBaseSiteLocationNumber do={
        :local hn [/system identity get name]
        :if ([:len $hn] < 12) do={
            :return ""
        }
        :local siteNum [:pick $hn 9 12]
        :if ([:typeof ($locationBaseMap->$siteNum)] = "nil") do={
            :return ""
        }
        :return $siteNum
    }

    # Function - Get the base location for the device from the baseSiteLocationNumber and locationBaseMap
    # Usage: :set $baseLocation [$getDeviceBaseLocation]
    :global getDeviceBaseLocation do={

        :if ([:len $baseSiteLocationNumber] = 0) do={
            :return ""
        }
        :local siteNumber ($baseSiteLocationNumber)
        :local baseLocation ($locationBaseMap->$baseSiteLocationNumber)
        :if ([:typeof $baseLocation] = "nil") do={
            :return ""
        }
        :return $baseLocation
    }

    # Function - Determine if the current site is a multi-building site
    # Uses getBaseSiteLocationNumber to get the site number, then checks dot count in locationBaseMap value
    # Returns "true" if value contains exactly 3 dots, else "false"
    :local isMultiBuildingSite do={
        :local siteNum [$getBaseSiteLocationNumber]
        :if ([:len $siteNum] = 0) do={
            :return "false"
        }
        :local value ($locationBaseMap->$siteNum)
        :if ([:typeof $value] = "nil") do={
            :return "false"
        }
        :local dotCount 0
        :for i from=0 to=([:len $value] - 1) do={
            :if ([:pick $value $i ($i + 1)] = ".") do={
                :set dotCount ($dotCount + 1)
            }
        }
        :if ($dotCount = 3) do={
            :return "true"
        } else={
            :return "false"
        }
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

    # Remove a global variable if it exists
    :global removeGlobalVariable do={
        :local varName $1
        :if ([:len $varName] > 0) do={
            /system script environment remove [find name=$varName]
        }
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


    # Set global variables to default/empty values
    :global hostname [/system identity get name]
    :global deviceType [$getDeviceType]
    :global deviceIp ""
    :global deviceIpCidr ""
    [$getIpFromHostname]
    :global baseSiteLocationNumber [$getBaseSiteLocationNumber]
    :global baseLocation [$getDeviceBaseLocation]
    :global multiBuildingSite [$isMultiBuildingSite]
    :global devicesSiteLocation [$readDeviceLocationAtSiteFile]
    :global deviceSerialNumber ""
    :global manufacturer ""
    :global deviceModel ""
    :global operatingSystem ""
    :global realLocation ""



    # Remove unwanted global variables

    $removeGlobalVariable "deviceTypeMap"
    $removeGlobalVariable "locationBaseMap"
    $removeGlobalVariable "multiBuildingLocationMap"

    # End of initializeVariables.rsc
}
