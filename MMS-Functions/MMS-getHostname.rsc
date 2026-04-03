# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260403154154
# Script Filename: MMS-getHostname.rsc
# Stored Script Name: MMS-getHostname
# Description: Prompts for and validates a device hostname, then stores it globally.
# Author: Kenneth G. Tipton
# Date: 2026-04-03
# Time: 15:41:54
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    global hostname
    # Get hostname function - Prompts user for a hostname, verifies it, and sets the global variable $hostname
    local getHostname do={
        :local verifyname do={
            :local hostnameDesignators {"acp";"rtr";"wrt";"swh"}
            :local hostnameDesignatorsCount ([:len $hostnameDesignators])
            :local validTempHostnameDesignator 
            :local TempHostnameDesignator 
            :local validHostname false
            :local tempHostnameLegth 
            :local validTempHostnameleghth
            :local tempHostname
            :local hostnameVerificationPhase
            # While loop to get and verify the hostname
            :while ($validHostname = false) do={
                :set $validTempHostnameDesignator false
                :set $TempHostnameDesignator ""                
                :set $validTempHostname false
                :set $tempHostnameLegth 0
                :set $validTempHostnameleghth false
                :set $tempHostname ""
                :set $hostnameVerificationPhase 0
                :put "\1Bc"
                :put "========================================================================================"
                :put " ___ ___ ____ __  _ ____   ___  ______ ____ __  _                     "
                :put "|   |   |    |  |/ |    \\ /   \\|      |    |  |/ ]                    "
                :put "| _   _ ||  ||  ' /|  D  |     |      ||  ||  ' /                     "
                :put "|  \\_/  ||  ||    \\|    /|  O  |_|  |_||  ||    \\                     "
                :put "|   |   ||  ||     |    \\|     | |  |  |  ||     \\                    "
                :put "|   |   ||  ||  .  |  .  |     | |  |  |  ||  .  |                    "
                :put "|___|___|__________|______\\_____ |____|_______|\\____ ____  ______     "
                :put "|   |   |/    |    \\ /    |/    | /  _|   |   | /  _|    \\|      |    "
                :put "| _   _ |  o  |  _  |  o  |   __|/  [_| _   _ |/  [_|  _  |      |    "
                :put "|  \\_/  |     |  |  |     |  |  |    _|  \\_/  |    _|  |  |_|  |_|    "
                :put "|   |   |  _  |  |  |  _  |  |_ |   [_|   |   |   [_|  |  | |  |      "
                :put "|   |   |  |  |  |  |  |  |     |     |   |   |     |  |  | |  |      "
                :put "|_______|________|_____|______________|___|___|_____|__|__| |__|      "
                :put " / ___/  /  |    \\|    |    \\|      |                                 "
                :put "(   \\_  /  /|  D  )|  ||  o  |      |                                 "
                :put " \\__  |/  / |    / |  ||   _/|_|  |_|                                 "
                :put " /  \\ /   \\_|    \\ |  ||  |    |  |                                   "
                :put " \\    \\     |  .  \\|  ||  |    |  |                                   "
                :put "  \\___|\\____|__|\\_|____|__|    |__|                                   "
                :put "                                                                      "
                :put "========================================================================================"
                :put "A properly formatted hostname is required for this script to run."
                :put "The hostname must be 15 characters long and starts with a three letter device designator"
                :put "(e.g. acp for access point, rtr for router, wrt for wireless router, swh for switch)."
                :put "The remaining 12 characters are the primary IPv4 address converted to a string"
                :put "(e.g. 10.10.37.5 becomes 010010037005 68.131.168.101 becomes 068131168101)."
                :put "For example an access point with an IPv4 of 172.138.43.22 hostname is acp172138043022."
                :put "========================================================================================"
                :set tempHostname [/terminal/ask preinput="Please enter the correct hostname (15 characters): "]
                :set $tempHostname [:pick $tempHostname 51 70]
                :set tempHostnameLegth [:len $tempHostname]
                :if ($tempHostnameLegth = 15) do={
                    :set $validTempHostnameleghth true
                    :put "Hostname length is valid."
                }
                :set $tempHostnameDesignator [:pick $tempHostname 0 3]
                :if ($tempHostnameLegth = 15) do={
                    :local loopCount 0
                    :set $tempHostnameDesignator [:pick $tempHostname 0 3] 
                    :while ($loopCount < $hostnameDesignatorsCount) do={
                        :if ($tempHostnameDesignator = ($hostnameDesignators->$loopCount)) do={ 
                            :set $validTempHostnameDesignator true
                            :put "Hostname designator $tempHostnameDesignator is valid."
                            :delay 5 
                            :set $loopCount 100
                        }
                        :set $loopCount ($loopCount + 1)
                        :put "Loop count is $loopCount"
                        :delay 10
                    }
                }
                :if ($tempHostnameLegth = 15 && $validTempHostnameDesignator = true) do={
                    :set $validTempHostname true
                    :put "Hostname is valid."
                } else={
                    :put "Hostname is invalid, please try again."
                    :delay 5
                }

                # Verify the Hostname input
                :if ($lenTempHostname = 15) do={
                    :local testHostname [/terminal/ask preinput="Please reenter the hostname to verify: "]
                    :set $testHostname [:pick $testHostname 39 54]
                    :local lenTestHostname [:len $testHostname]
                    :if ($tempHostname = $testHostname) do={
                        :put "Hostname is valid and set to: $tempHostname"
                        :delay 5
                        :set $hostname $tempHostname
                        :set $validHostname true
                    } else={
                        :put "Hostnames $tempHostname and $testHostname do not match, please try again."
                        :delay 5
                    }
                }
            }
            :put $tempHostname
            :return $validHostname
        }
        $verifyname
    }
    $getHostname
    #/system script environment remove getHostname
}

