# MikroTik Management Scripts
# MMS Version: 0.01 Testing
{    
    # Key variable for entire script
    global hostName [/system identity get name]

    global convertIPStringToIP do={

    }
    
    global getHostname do={
        :local verifyname do={
            :local validHostname false
            while ($validHostname = false) do={
                :put "\1Bc"
                :local read do={:return}
                :local tempHostname [$read "Please enter the correct hostname (15 characters): "]
                :if ([:len $tempHostname] = 15) do={
                    :local read do={:return}
                    :local testHostname [$read "Please reenter the hostname to verify: "]
                }
            }
        }

    }
        :local inputHostname do={
            :local validInput false
            :while ($validInput = false) do={
                :put "\1Bc"
                :local read do={:return}
                :local tempHostname [$read "Please enter the correct hostname (15 characters): "]
                :if ([:len $tempHostname] = 15) do={
                    :local read do={:return}
                    :local testHostname [$read "Please reenter the hostname to verify: "]
                    :local key
                    :put "Is $tempHostname correct Y/N :"
                    :set key [:read char]
                    if ($key = "y") do={
                        :put "You confirmed YES"
                        :delay 4
                        :set $validHostname true
                    } else if ($key = "n") do={
                        :put "You chose NO"
                        delay 4
                        :put "\1Bc"
                    } else={
                        :put "Invalid input."
                        delay 4
                        :put "\1Bc"
                    }
                } else={
                    :put ("\n \033[0;31mInvalid hostname length. Please enter a hostname with exactly 15 characters.\033[0m")
                    :delay 4
                    :put "\1Bc"
                }
            }
        }
    }

    if ([/system identity get name] = "mikrotik") do={
        getHostname
    }

    # Set common variables
    global companyDesignator "GGI"
    global residentDesignator "GGR"

    global ipAsString [:pick $hostName 3 15]
    global hostDesignator [:pick $hostName 9 15]
    global a [:tonum ([:pick $ipAsString 1 3])]
    global b [:tonum ([:pick $ipAsString 3 6])]
    global c [:tonum ([:pick $ipAsString 6 9])]
    global d [:tonum ([:pick $ipAsString 9 12])]
    global ipBridgeGGI ("$a.$b.$c.$d/24")
    global ipBridgeGGILB ("192.168.$c.$d/32")
    global ipBridgeGGR ("172.17.$c.$d/24")
    global ipBridgeGGRLB ("172.20.$c.$d/32")

    # Set the names for the bridge variables
    global bridgeGGI "BRDG-$companyDesignator-$hostDesignator-$ipAsString-24"
    global bridgeGGILB "BRDG-$companyDesignator-$hostDesignator-192168$hostDesignator-32"
    global bridgeGGR "BRDG-$companyDesignator-$hostDesignator-172017$hostDesignator-24"
    global bridgeGGRLB "BRDG-$companyDesignator-$hostDesignator-172020$hostDesignator-32"

    global bridgeGGIIP

    # Set the name for the bond variable
    global bondGGI "BOND-$companyDesignator-$hostDesignator-$ipAsString-24"
}