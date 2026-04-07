# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260407125652
# Script Filename: MMS-getSubnetCidrFromHostname.rsc
# Stored Script Name: MMS-getSubnetCidrFromHostname
# Description: Returns subnet network in CIDR notation parsed from a standard MMS hostname.
# Author: Kenneth G. Tipton
# Date: 2026-04-07
# Time: 12:56:52
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    # Usage:
    #   :global MMSgetSubnetCidrFromHostname
    #   :put [$MMSgetSubnetCidrFromHostname "acp010010054010024"]
    #   :put [$MMSgetSubnetCidrFromHostname "rtr047049224234029"]
    :global MMSgetSubnetCidrFromHostname do={
        :local hostName [:tostr $1]
        :if ([:len $hostName] < 18) do={ :return "" }

        :local oct1 [:tonum [:pick $hostName 3 6]]
        :local oct2 [:tonum [:pick $hostName 6 9]]
        :local oct3 [:tonum [:pick $hostName 9 12]]
        :local oct4 [:tonum [:pick $hostName 12 15]]
        :local cidrBits [:tonum [:pick $hostName 15 18]]

        :if (([:typeof $oct1] = "nil") || ([:typeof $oct2] = "nil") || ([:typeof $oct3] = "nil") || ([:typeof $oct4] = "nil") || ([:typeof $cidrBits] = "nil")) do={
            :return ""
        }

        :if (($oct1 < 0 || $oct1 > 255) || ($oct2 < 0 || $oct2 > 255) || ($oct3 < 0 || $oct3 > 255) || ($oct4 < 0 || $oct4 > 255)) do={
            :return ""
        }

        :if ($cidrBits < 0 || $cidrBits > 32) do={
            :return ""
        }

        :local fullOctets ($cidrBits / 8)
        :local partialBits ($cidrBits - ($fullOctets * 8))

        :local n1 0
        :local n2 0
        :local n3 0
        :local n4 0

        :if ($fullOctets >= 1) do={ :set n1 $oct1 }
        :if ($fullOctets >= 2) do={ :set n2 $oct2 }
        :if ($fullOctets >= 3) do={ :set n3 $oct3 }
        :if ($fullOctets >= 4) do={ :set n4 $oct4 }

        :if ($fullOctets < 4 && $partialBits > 0) do={
            # Compute 2^(8-partialBits) without :pow for broader RouterOS compatibility.
            :local blockSize 1
            :local steps (8 - $partialBits)
            :for i from=1 to=$steps do={
                :set blockSize ($blockSize * 2)
            }
            :if ($fullOctets = 0) do={ :set n1 (($oct1 / $blockSize) * $blockSize) }
            :if ($fullOctets = 1) do={ :set n2 (($oct2 / $blockSize) * $blockSize) }
            :if ($fullOctets = 2) do={ :set n3 (($oct3 / $blockSize) * $blockSize) }
            :if ($fullOctets = 3) do={ :set n4 (($oct4 / $blockSize) * $blockSize) }
        }

        :return (($n1 . "." . $n2 . "." . $n3 . "." . $n4) . "/" . $cidrBits)
    }
}
