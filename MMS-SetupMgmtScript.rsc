# Version: 202504031352
# Script Name: MMS-SetupMgmtScript
# Script file created by: Kenneth Tipton
# Telecommunications Networking and Computing, Inc.
#
# Used for initial Setup of Management Scripts
{
    # Mikrotik Management Scripts Setup
    :log info "Starting a Mikrotik Management Scripts update/Install"
    :log info "Geting Mikrotik Scripts login information"
    :local hasErrors "false"
    :local mikrotikScriptsFTPPassword  [/ppp secret get [/ppp secret find name="MikrotikScripts"] password]
    :log info "Setup Mikrotik Mgmt Scripts"
    :log info "Delete any previous Mikrotik Management Scripts that exist"
    foreach objFile in=[/file find where (type="script")] do={
        :set $filename [/file get $objFile name]
        :set $fileOrigin [:pick [/file get $objFile name] 0 4]
        :if ($fileOrigin = "MMS-") do={
            :log info "Deleting Mikrotik Management Script $filename"
            [/file remove $objFile]
        }
    }
    :delay 5
    # Download latest copy of MMS-InstallScripts.rsc"
    /tool fetch address="srv010010037045.generationsgaither.com" src-path="/MMS-InstallScripts.rsc" user="MikrotikScripts" mode=ftp password="$mikrotikScriptsFTPPassword" dst-path="MMS-InstallScripts.rsc" 
    :log info "Downloading Mikrotik Management Scripts control script MMS-InstallScripts.rsc downloading"
    :delay 10
    # Get MMS-InstallSripts.rsc file Version"
    :put [:len [/file find name="MMS-InstallScripts.rsc"]]
    :if ([:len [/file find name="MMS-InstallScripts.rsc"]] > 0) do={
        :local cont [/file get MMS-InstallScripts.rsc contents]
        :local fileVersion [:pick $cont 11 23]
        :if ([ :len [ /system/script/find where name="MMS-InstallScripts" ] ] = 0) do={
            :log info "Script MMS-InstallScript does not exist, creating script"
            /system/script add name="MMS-InstallScripts" owner=admin source=$cont
            # Implement Later
            # /system script run installScripts
        } else={
            # Get stored script MMS-InstallSripts file Version"
            :set $cont [ /system/script/get [/system/script find where name=MMS-InstallScripts] source ]
            :local scriptVersion [:pick $cont 11 23]
            :if ($fileVersion>$scriptVersion) do={
                /system script set [find name=MMS-InstallScripts] source=$cont
                :log info "MMS-InstallScripts script updated to version $fileVersion from version $scriptVersion"
                :delay 5
            } else={
                :log info "MMS-InstallScripts script is newest version $scriptVersion"
            }
        }
        :delay 3
        foreach objFile in=[/file find where (type="script")] do={
            :set $filename [/file get $objFile name]
            :set $fileOrigin [:pick [/file get $objFile name] 0 4]
            :if ($fileOrigin = "MMS-") do={
                :log info "Deleting Mikrotik Management Script $filename"
                [/file remove $objFile]
            }
        }
        # Schedule InstallScripts to execute every day
        :if ([:len [/system scheduler find name="020.MMS-InstallScripts"]] = 0) do={
            /system scheduler add name=020.MMS-InstallScripts start-time=23:15:00 interval=1d on-event="/system script run MMS-InstallScripts"
            :delay 5
            :log info "Stored scripts 020.MMS-InstallScripts schedule created and set to run once a day at 11:15 PM"
        } else={
            /system scheduler set [find name=020.MMS-InstallScripts] name=020.MMS-InstallScripts start-time=23:15:00 interval=1d on-event="/system script run MMS-InstallScripts"
            :delay 5
            :log info "Stored script 020.MMS-InstallScripts schedule has been updated to run once a day at 11:15 PM"
        }     
    } else={
        :log info "Mikrotik Management Scripts Control Script failed to download"

    }
    :if ($hasErrors = "false") do={
        :log info "Mikrotik Management Script MMS-SetupMgmtScript Completed without errors"
    } else={
        :log info "Mikrotik Management Script MMS-SetupMgmtScript Completed with errors"
    }
    
}
