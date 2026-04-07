# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260407115148
# Script Filename: MMS-getIpv4FromHostname.rsc
# Stored Script Name: MMS-getIpv4FromHostname
# Description: Returns IPv4 address string parsed from a standard MMS hostname.
# Author: Kenneth G. Tipton
# Date: 2026-04-07
# Time: 11:51:48
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    # Usage:
    #   :global MMSgetIpv4FromHostname
    #   :put [$MMSgetIpv4FromHostname "acp010010054010024"]
    :global MMSgetIpv4FromHostname do={
        :local hostName [:tostr $1]
        :if ([:len $hostName] < 18) do={ :return "" }

        :local oct1 [:tonum [:pick $hostName 3 6]]
        :local oct2 [:tonum [:pick $hostName 6 9]]
        :local oct3 [:tonum [:pick $hostName 9 12]]
        :local oct4 [:tonum [:pick $hostName 12 15]]

        :if (([:typeof $oct1] = "nil") || ([:typeof $oct2] = "nil") || ([:typeof $oct3] = "nil") || ([:typeof $oct4] = "nil")) do={
            :return ""
        }

        :if (($oct1 < 0 || $oct1 > 255) || ($oct2 < 0 || $oct2 > 255) || ($oct3 < 0 || $oct3 > 255) || ($oct4 < 0 || $oct4 > 255)) do={
            :return ""
        }

        :return ($oct1 . "." . $oct2 . "." . $oct3 . "." . $oct4)
    }
}
