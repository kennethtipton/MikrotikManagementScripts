# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260407114730
# Script Filename: MMS-isIpInSubnet.rsc
# Stored Script Name: MMS-isIpInSubnet
# Description: Returns true when a given IP address is inside a given subnet CIDR.
# Author: Kenneth G. Tipton
# Date: 2026-04-07
# Time: 11:47:30
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    # Determines whether an IP belongs to a subnet.
    # Usage examples:
    #   :global MMSisIpInSubnet
    #   :put [$MMSisIpInSubnet "10.10.54.10" "10.10.54.0/24"]
    #   :put [$MMSisIpInSubnet "69.8.161.137" "69.8.161.136/29"]
    :global MMSisIpInSubnet do={
        :local inputIp [:tostr $1]
        :local inputSubnet [:tostr $2]

        :if ([:len $inputIp] = 0 || [:len $inputSubnet] = 0) do={
            :return false
        }

        :local ipValue ""
        :local subnetValue ""

        :do {
            :set ipValue [:toip $inputIp]
        } on-error={
            :return false
        }

        :do {
            :set subnetValue [:toip $inputSubnet]
        } on-error={
            :return false
        }

        :do {
            :if ($ipValue in $subnetValue) do={
                :return true
            }
        } on-error={
            :return false
        }

        :return false
    }
}
