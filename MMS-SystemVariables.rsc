# Version: 202504021153
# Script Name: MMS-SystemVariables
# Script file created by Kenneth Tipton
# Telecommunications Networking and Computing, Inc.
#
# Verify the Device has a Sytem Identity
:if ( [/system identity get name] != "Mikrotik") do={
    # Verify the Device's System Identity is 15 Characters long 
    # (a three letter designator followed by the ip address)
    :if ([:len [/system identity get name]] = 15) do={
        # Store common information in global variables
        #---------------------------------------------
        # create global variable "deviceModelNumber" to store Mikrotik model number
        :global deviceModelNumber
        # create global variable "deviceDesc" to store Mikrotik Board Name
        :global deviceDesc
        # create global variable "deviceType" to store Mikrotik device type 
        # (e.g. "Access_Point";"Switch";"Wireless_Router";"Router")
        :global deviceType
        #create a global variable "deviceSerialNumber" to store current device's serial number
        :global deviceSerialNumber [/system routerboard get serial-number]
        # Create global variable "ftpScriptServer" to store fqdn for ftp script storage server
        :global ftpScriptServer "srv010010037045.generationsgaither.com"
        # Create global variable "ftpBackupServer" to store Current device's restore scripts and backup files 
        # server location
        :global ftpBackupServer "backupftp.generationsgaither.com"


        # Get Mikrotik Device Infomation an store in deviceInfo        
        :local deviceInfo [/system/routerboard/get]
        # :put $deviceInfo

        # Create global variable "emailServer" to store Mikrotik current email server
        # :global emailServer
        :global emailServer
        :set $emailServer ("smtp.generatiosngaither.com")

        # Create global variable "toEmailAddress" to store current email addresses fir notification
        # :global emailAddress
        :global toEmailAddress
        :set $toEmailAddress ("server@generatiosngaither.com")

        # Initialize an empty array
        :local deviceInfoArray [];
        :set $deviceInfoArray [:toarray $deviceInfo]
        :foreach fieldName,fieldValue in=$deviceInfoArray do={
            # Get the Device "model" Number
            :if ([:pick $fieldName 0 5] = "model") do={
                :set $deviceModelNumber [:pick $fieldValue 0 30]
            }        
            # Get the Device "board-name"
            :if ([:pick $fieldName 0 10] = "board-name") do={
                :set $deviceDesc [:pick $fieldValue 0 30]
            }
        }

        # Store Hostname of device in variable deviceHostName
        :global deviceHostname [/system identity get name]
        # Zone number as String (three charicters long)
        :global deviceZoneConstant [:pick $deviceHostname 9 12]
        # Zone number as integer
        :global deviceZoneIPConstant [:tonum [:pick $deviceHostname 9 12]]
        # Device's Defining Internet Protocol Address number as integer
        :global deviceIPConstant [:tonum [:pick $deviceHostname 12 15]]
        :global deviceIPDesinator [:tostr [:pick $deviceHostname 9 15]]
        :global deviceIPString [:tostr [:pick $deviceHostname 3 15]] 

        # Create global variable "fromEmailAddress" to store device from email addresses for notification
        # :global emailAddress
        :global fromEmailAddress
        :set $fromEmailAddress ("$deviceHostname@generatiosngaither.com")

        # Define Device Type
        :local deviceTypeDesignator [:pick $deviceHostname 0 3]
        :if ($deviceTypeDesignator = "acp") do={
            :set $deviceType "ACCESS_POINT"
        }
        :if ($deviceTypeDesignator = "swh") do={
            :set $deviceType "SWITCH"
        }
        :if ($deviceTypeDesignator = "rtr") do={
            :set $deviceType "ROUTER"
        }
        :if ($deviceTypeDesignator = "wrt") do={
            :set $deviceType "WIRELESS_ROUTER"
        }
    }
}
