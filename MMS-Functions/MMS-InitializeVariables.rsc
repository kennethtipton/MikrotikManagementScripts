# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260403154154
# Script Filename: MMS-InitializeVariables.rsc
# Stored Script Name: MMS-InitializeVariables
# Description: Initializes global variables commonly used in Mikrotik RouterOS scripts.
# Author: Kenneth G. Tipton
# Date: 2026-04-03
# Time: 15:41:54
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    # Data Mapping and Variable Initialization Script for Mikrotik RouterOS

    # Set to true to suppress screen output, false to show common variable values.
    :global silent true

    # ===============================
    # Import dataset maps from external files
    # If imports fail, run MMS-dataSetMapSync, wait 10 seconds, and retry imports.
    # ===============================
    :local importDataSetMaps do={
        :local allOk true
        :do {
            /import file-name=dataSets/dataSetMapDeviceType.rsc
            :if ($silent = false) do={ :put "Imported dataSetMapDeviceType" }
            :log info "initializeVariables: Imported dataSetMapDeviceType"
        } on-error={
            :set allOk false
            :log error "initializeVariables: Failed to import dataSetMapDeviceType"
            :if ($silent = false) do={ :put "ERROR: Failed to import dataSetMapDeviceType" }
        }
        :do {
            /import file-name=dataSets/dataSetMapLocationBase.rsc
            :if ($silent = false) do={ :put "Imported dataSetMapLocationBase" }
            :log info "initializeVariables: Imported dataSetMapLocationBase"
        } on-error={
            :set allOk false
            :log error "initializeVariables: Failed to import dataSetMapLocationBase"
            :if ($silent = false) do={ :put "ERROR: Failed to import dataSetMapLocationBase" }
        }
        :do {
            /import file-name=dataSets/dataSetMapDeviceLocationAtSite.rsc
            :if ($silent = false) do={ :put "Imported dataSetMapDeviceLocationAtSite" }
            :log info "initializeVariables: Imported dataSetMapDeviceLocationAtSite"
        } on-error={
            :set allOk false
            :log error "initializeVariables: Failed to import dataSetMapDeviceLocationAtSite"
            :if ($silent = false) do={ :put "ERROR: Failed to import dataSetMapDeviceLocationAtSite" }
        }
        :return $allOk
    }

    :if ([$importDataSetMaps] = false) do={
        :log warning "initializeVariables: Dataset maps missing; running MMS-dataSetMapSync and retrying in 10 seconds."
        :if ($silent = false) do={ :put "Dataset maps missing; running MMS-dataSetMapSync and waiting 10 seconds..." }
        :do {
            /system script run "MMS-dataSetMapSync"
        } on-error={
            :log error "initializeVariables: Failed to run MMS-dataSetMapSync"
            :if ($silent = false) do={ :put "ERROR: Failed to run MMS-dataSetMapSync" }
        }
        :delay 10s

        :if ([$importDataSetMaps] = false) do={
            :log error "initializeVariables: Dataset maps still missing after MMS-dataSetMapSync retry."
            :if ($silent = false) do={ :put "ERROR: Dataset maps still missing after retry." }
            :error "Required dataset maps are missing"
        }
    }
    # Diagnostic: Show type and sample of imported variables
    :if ($silent = false) do={
        :put ("dataSetMapDeviceType type: " . [:typeof $dataSetMapDeviceType])
        :put ("dataSetMapLocationBase type: " . [:typeof $dataSetMapLocationBase])
        :put ("dataSetMapDeviceLocationAtSite type: " . [:typeof $dataSetMapDeviceLocationAtSite])
        :if ([:typeof $dataSetMapDeviceLocationAtSite] = "array") do={
            :local hn [/system identity get name]
            :put ("Looking up hostname: " . $hn)
            :local found ($dataSetMapDeviceLocationAtSite->$hn)
            :put ("Found value type: " . [:typeof $found])
            :put ("Found value: " . $found)
        }
    } 
    # Functions to initialize global variables for device information and mappings.

    # Function - Resolve device location at site and store in devicesSiteLocation.
    # Lookup order:
    #   1) dataSetMapDeviceLocationAtSite using hostname key
    #   2) Parse dataSets/dataSetMapDeviceLocationAtSite.rsc directly (fallback)
    #   3) deviceLocationAtSite.txt contents (fallback)
    # Returns "" if neither source has a value.
    :global devicesSiteLocation ""
    :local readDeviceLocationAtSiteFile do={
        :global dataSetMapDeviceLocationAtSite
        :local hn [/system identity get name]
        :local mapValue ($dataSetMapDeviceLocationAtSite->$hn)
        :if ([:typeof $mapValue] != "nil" && [:len $mapValue] > 0) do={
            :global devicesSiteLocation $mapValue
            :return $devicesSiteLocation
        }

        :local dataSetFile "dataSets/dataSetMapDeviceLocationAtSite.rsc"
        :if ([/file find name=$dataSetFile] != "") do={
            :local raw [/file get $dataSetFile contents]
            :local marker ("\"" . $hn . "\"")
            :local markerPos [:find $raw $marker]
            :if ([:typeof $markerPos] != "nil") do={
                :local eqPos [:find $raw "=" $markerPos]
                :if ([:typeof $eqPos] != "nil") do={
                    :local quote1 [:find $raw "\"" ($eqPos + 1)]
                    :if ([:typeof $quote1] != "nil") do={
                        :local quote2 [:find $raw "\"" ($quote1 + 1)]
                        :if ([:typeof $quote2] != "nil" && $quote2 > $quote1) do={
                            :local parsedValue [:pick $raw ($quote1 + 1) $quote2]
                            :if ([:len $parsedValue] > 0) do={
                                :global devicesSiteLocation $parsedValue
                                :return $devicesSiteLocation
                            }
                        }
                    }
                }
            }
        }

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
    # Returns the site number if found in dataSetMapLocationBase, else ""
    :local getBaseSiteLocationNumber do={
        :global dataSetMapLocationBase
        :local hn [/system identity get name]
        :if ([:len $hn] < 12) do={
            :return ""
        }
        :local siteNum [:pick $hn 9 12]
        :if ([:typeof ($dataSetMapLocationBase->$siteNum)] = "nil") do={
            :return ""
        }
        :return $siteNum
    }

    # Function - Get the base site location name for the device from the baseSiteLocationNumber and dataSetMapLocationBase
    # Usage: :set $baseSiteLocationName [$getDeviceBaseLocation]
    :global getDeviceBaseLocation do={
        :global dataSetMapLocationBase

        :if ([:len $baseSiteLocationNumber] = 0) do={
            :return ""
        }
        :local siteNumber ($baseSiteLocationNumber)
        :local baseLocation ($dataSetMapLocationBase->$baseSiteLocationNumber)
        :if ([:typeof $baseLocation] = "nil") do={
            :return ""
        }
        :return $baseLocation
    }

    # Function - Determine if the current site is a multi-building site
    # Uses getBaseSiteLocationNumber to get the site number, then checks dot count in dataSetMapLocationBase value
    # Returns "true" if value contains exactly 3 dots, else "false"
    :local isMultiBuildingSite do={
        :global dataSetMapLocationBase
        :local siteNum [$getBaseSiteLocationNumber]
        :if ([:len $siteNum] = 0) do={
            :return "false"
        }
        :local value ($dataSetMapLocationBase->$siteNum)
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

    # Function - Get the standard comment base by combining the base location with the device location at site
    # The base location (from dataSetMapLocationBase) is first, followed by a period, then the device location at site
    # (from dataSetMapDeviceLocationAtSite). For multi-building sites, the building info is embedded in the
    # device location at site value, so no separate multi-building map is needed.
    # Example: "GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD.KOLTON_WAYNE_HOUSE.HOUSE_MANAGERS_OFFICE"
    :local getDeviceFullSiteLocationName do={
        :global dataSetMapLocationBase
        :global dataSetMapDeviceLocationAtSite
        :local hn [/system identity get name]
        :if ([:len $baseSiteLocationNumber] = 0) do={
            :return ""
        }
        :local baseLocation ($dataSetMapLocationBase->$baseSiteLocationNumber)
        :if ([:typeof $baseLocation] = "nil") do={
            :return ""
        }
        :local deviceLocation ($dataSetMapDeviceLocationAtSite->$hn)
        :if ([:typeof $deviceLocation] = "nil") do={
            :return $baseLocation
        }
        :return ($baseLocation . "." . $deviceLocation)
    }

    # Function - Get the device type name from the hostname designator and store abbreviation/name as globals
    :local getDeviceTypeName do={
        :global dataSetMapDeviceType
        :local tempHostname [/system identity get name]
        :local abbrev [:pick $tempHostname 0 3]
        :global deviceTypeAbreviation $abbrev
        :global deviceTypeName ($dataSetMapDeviceType->$abbrev)
        :if ([:typeof $deviceTypeName] = "nil") do={
            :set $deviceTypeName "UNKNOWN"
        }
        :return $deviceTypeName
    }

    # Remove a global variable if it exists
    :local removeGlobalVariable do={
        :local varName $1
        :if ([:len $varName] > 0) do={
            :local envIds [/system script environment find where name=$varName]
            :foreach envId in=$envIds do={
                /system script environment remove $envId
            }
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

    # Function - Get the model of the device from system routerboard with system resource fallback
    :local getDeviceModel do={
        :do {
            :local model [/system routerboard get model]
            :if ([:len $model] > 0) do={
                :return $model
            }
        } on-error={
        }
        :return [/system resource get board-name]
    }

    # Function - Get the board name of the device from system routerboard with system resource fallback
    :local getDeviceBoardName do={
        :do {
            :local boardName [/system routerboard get board-name]
            :if ([:len $boardName] > 0) do={
                :return $boardName
            }
        } on-error={
        }
        :return [/system resource get board-name]
    }

    # Function - Get the manufacturer of the device
    :local getDeviceManufacturer do={
        :do {
            :if ([/system routerboard get routerboard] = true) do={
                :return "MikroTik"
            }
        } on-error={
        }
        :local platform [/system resource get platform]
        :if ([:len $platform] > 0) do={
            :return $platform
        }
        :return ""
    }

    # Function - Get the operating system name and version
    :local getOperatingSystem do={
        :local version [/system resource get version]
        :if ([:len $version] > 0) do={
            :return ("RouterOS " . $version)
        }
        :return "RouterOS"
    }

    # Function - Get the device serial number from system routerboard with fallback
    :local getDeviceSerialNumber do={
        :do {
            :local serialNumber [/system routerboard get serial-number]
            :if ([:len $serialNumber] > 0) do={
                :return $serialNumber
            }
        } on-error={
        }
        :return ""
    }

    # Display common initialized variables when silent is false.
    :local outputCommonVariables do={
        :if ($silent = true) do={
            :return ""
        }
        :put "=== Identity ==="
        :put ("deviceTypeAbreviation=" . $deviceTypeAbreviation)
        :put ("deviceTypeName=" . $deviceTypeName)
        :put ("hostname=" . $hostname)

        :put "=== Location ==="
        :put ("baseSiteLocationName=" . $baseSiteLocationName)
        :put ("baseSiteLocationNumber=" . $baseSiteLocationNumber)
        :put ("devicesSiteLocation=" . $devicesSiteLocation)
        :put ("deviceFullSiteLocationName=" . $deviceFullSiteLocationName)
        :put ("multiBuildingSite=" . $multiBuildingSite)

        :put "=== Network ==="
        :put ("deviceIp=" . $deviceIp)
        :put ("deviceIpCidr=" . $deviceIpCidr)

        :put "=== Device Details ==="
        :put ("deviceBoardName=" . $deviceBoardName)
        :put ("deviceManufacturer=" . $deviceManufacturer)
        :put ("deviceModel=" . $deviceModel)
        :put ("deviceOperatingSystem=" . $deviceOperatingSystem)
        :put ("deviceSerialNumber=" . $deviceSerialNumber)
        :return ""
    }


    # Set global variables to default/empty values
    :global hostname [/system identity get name]
    :global deviceTypeAbreviation ""
    :global deviceTypeName [$getDeviceTypeName]
    :global deviceIp ""
    :global deviceIpCidr ""
    [$getIpFromHostname]
    :global baseSiteLocationNumber [$getBaseSiteLocationNumber]
    :global baseSiteLocationName [$getDeviceBaseLocation]
    :global multiBuildingSite [$isMultiBuildingSite]
    :global deviceFullSiteLocationName [$getDeviceFullSiteLocationName]
    :global devicesSiteLocation [$readDeviceLocationAtSiteFile]
    :global deviceSerialNumber [$getDeviceSerialNumber]
    :global deviceManufacturer [$getDeviceManufacturer]
    :global deviceModel [$getDeviceModel]
    :global deviceBoardName [$getDeviceBoardName]
    :global deviceOperatingSystem [$getOperatingSystem]

    $outputCommonVariables
    # Remove all globals created by this script except the required persistent set.
    :foreach varName in={
        "getDeviceBaseLocation";
        "dataSetMapDeviceLocationAtSite";
        "dataSetMapDeviceType";
        "dataSetMapLocationBase";
        "deviceTypeMap";
        "locationBaseMap";
        "multiBuildingLocationMap";
        "listPPPSecrets";
        "downloadDataSetMaps"
    } do={
        $removeGlobalVariable $varName
    }
    # End of initializeVariables.rsc
}
