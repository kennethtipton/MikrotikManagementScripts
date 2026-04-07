# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260405160315
# Script Filename: MMS-updateHostnameFromDataSetMapDeviceLocationAtSite.rsc
# Stored Script Name: MMS-updateHostnameFromDataSetMapDeviceLocationAtSite
# Description: Updates system identity by matching device IP to a hostname key in dataSetMapDeviceLocationAtSite.
# Author: Kenneth G. Tipton
# Date: 2026-04-05
# Time: 16:03:15
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    # Usage examples:
    #   :global MMSupdateHostnameFromDataSetMapDeviceLocationAtSite
    #   $MMSupdateHostnameFromDataSetMapDeviceLocationAtSite
    #   $MMSupdateHostnameFromDataSetMapDeviceLocationAtSite "10.10.37.2"
    #   $MMSupdateHostnameFromDataSetMapDeviceLocationAtSite "10.10.37.2" false
    #
    # Parameter 1 (optional): target IPv4 to match against hostname-derived IPv4 values.
    #                         If omitted, the script uses the first local /ip address (without CIDR).
    # Parameter 2 (optional): apply change flag; true updates identity, false is dry-run.

    :global MMSupdateHostnameFromDataSetMapDeviceLocationAtSite do={
        :global dataSetMapDeviceLocationAtSite

        :local targetIp ""
        :local applyChange true
        :local currentHostname [/system identity get name]
        :local matchedHostname ""
        :local matchCount 0

        :if ([:len $1] > 0) do={
            :set targetIp $1
        }

        :if ([:len $2] > 0) do={
            :if (($2 = true) || ($2 = "true") || ($2 = "yes") || ($2 = "1")) do={
                :set applyChange true
            } else={
                :set applyChange false
            }
        }

        :if ([:typeof $dataSetMapDeviceLocationAtSite] != "array") do={
            :local imported false
            :do {
                /import file-name="dataSets/dataSetMapDeviceLocationAtSite.rsc"
                :set imported true
            } on-error={
            }
            :if ($imported = false) do={
                :do {
                    /import file-name="dataSetMaps/dataSetMapDeviceLocationAtSite.rsc"
                    :set imported true
                } on-error={
                }
            }
            :if ([:typeof $dataSetMapDeviceLocationAtSite] != "array") do={
                :log warning "MMSupdateHostnameFromDataSetMapDeviceLocationAtSite: dataSetMapDeviceLocationAtSite is not available."
                :return "failed"
            }
        }

        :if ([:len $targetIp] = 0) do={
            :local addressId ""
            :set addressId [:pick [/ip address find where disabled=no and dynamic=no] 0]
            :if ([:len $addressId] = 0) do={
                :set addressId [:pick [/ip address find where disabled=no] 0]
            }
            :if ([:len $addressId] = 0) do={
                :log warning "MMSupdateHostnameFromDataSetMapDeviceLocationAtSite: no local IP address found."
                :return "failed"
            }

            :local localAddress [/ip address get $addressId address]
            :local slashPos [:find $localAddress "/"]
            :if ([:typeof $slashPos] = "nil") do={
                :set targetIp $localAddress
            } else={
                :set targetIp [:pick $localAddress 0 $slashPos]
            }
        }

        :foreach hostKey,siteValue in=$dataSetMapDeviceLocationAtSite do={
            :if ([:len $hostKey] = 18) do={
                :local a [:tonum [:pick $hostKey 3 6]]
                :local b [:tonum [:pick $hostKey 6 9]]
                :local c [:tonum [:pick $hostKey 9 12]]
                :local d [:tonum [:pick $hostKey 12 15]]
                :local derivedIp ("$a.$b.$c.$d")

                :if ($derivedIp = $targetIp) do={
                    :set matchCount ($matchCount + 1)
                    :if ([:len $matchedHostname] = 0) do={
                        :set matchedHostname $hostKey
                    }
                }
            }
        }

        :if ($matchCount = 0) do={
            :log warning ("MMSupdateHostnameFromDataSetMapDeviceLocationAtSite: no hostname match found for IP " . $targetIp)
            :return "failed"
        }

        :if ($matchCount > 1) do={
            :log warning ("MMSupdateHostnameFromDataSetMapDeviceLocationAtSite: multiple hostnames matched IP " . $targetIp . "; using first match " . $matchedHostname)
        }

        :if ($currentHostname = $matchedHostname) do={
            :log info ("MMSupdateHostnameFromDataSetMapDeviceLocationAtSite: identity already correct: " . $currentHostname)
            :return $currentHostname
        }

        :if ($applyChange = true) do={
            /system identity set name=$matchedHostname
            :log info ("MMSupdateHostnameFromDataSetMapDeviceLocationAtSite: updated identity from " . $currentHostname . " to " . $matchedHostname . " using IP " . $targetIp)
        } else={
            :log info ("MMSupdateHostnameFromDataSetMapDeviceLocationAtSite: dry-run for IP " . $targetIp . "; would update identity from " . $currentHostname . " to " . $matchedHostname)
        }

        :return $matchedHostname
    }
}
