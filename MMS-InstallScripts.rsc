# Version: 202504031357
# Script Name: MMS-InstallScripts
# Script file created by Kenneth Tipton
# Telecommunications Networking and Computing, Inc.
#
# Used to install and update mangement scripts and schedule them.
# Also use to update initial setup script
{
    :log info "Install/Update Mikrotik Management Scripts"
    :local secretName "MikrotikScripts"
    :local secretValue  [/ppp secret get [/ppp secret find name=$secretName] password]
    :local ftppass "$secretValue"
    :local ftpServer "srv010010037045.generationsgaither.com"
    # Delete any Mikrotik Management Scripts before starting
    foreach objFile in=[/file find where (type="script")] do={
        :set $filename [/file get $objFile name]
        :set $fileOrigin [:pick [/file get $objFile name] 0 4]
        if ($fileOrigin = "MMS-") do={
            :log info "Deleting Mikrotik Management Script $filename"
            [/file remove $objFile]
        }
    }
    :log info "Download mail install script MMS-SetupMgmtScript.rsc"
    /tool fetch address="srv010010037045.generationsgaither.com" src-path="/MMS-SetupMgmtScript.rsc" user="$secretName" mode=ftp password="$secretValue" dst-path="MMS-SetupMgmtScript.rsc" 
    :delay 10
    :if ([:len [/file find name="MMS-SetupMgmtScript.rsc"]] > 0) do={
        :if ([ :len [ /system/script/find where name="MMS-SetupMgmtScript" ] ] > 0) do={
            :local cont [/file get MMS-SetupMgmtScript.rsc contents]
            :local fileVersion [:pick $cont 11 23]
            :if ([ :len [ /system/script/find where name="MMS-SetupMgmtScript" ] ] = 0) do={
                :log info "Script MMS-SetupMgmtScript does not exist, creating script"
                /system/script add name="MMS-SetupMgmtScript" owner=admin source=$cont
                # Implement Later
                # /system script run SetupMgmtScript
            } else={
                # Get stored script MMS-InstallSripts file Version"
                :set $cont [ /system/script/get [/system/script find where name=MMS-SetupMgmtScript] source ]
                :local scriptVersion [:pick $cont 11 23]
                :if ($fileVersion>$scriptVersion) do={
                    /system script set [find name=MMS-SetupMgmtScript] source=$cont
                    :log info "MMS-SetupMgmtScript script updated to version $fileVersion from version $scriptVersion"
                    :delay 5
                } else={
                    :log info "MMS-SetupMgmtScript script is newest version $scriptVersion"
                }
            }
        } else={
            :log info "Script file MMS-SetupMgmtScript.rsc not found"
        }
    }    
}
