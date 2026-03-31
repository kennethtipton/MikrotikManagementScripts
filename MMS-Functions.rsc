{
    # Setup global variable ftpScript server if MMS-SystemVariables.rsc hans never beem executed
    :global ftpScriptServer
    :if (:len[ftpScriptServer] = 0) {
        :set ftpScriptServer "srv010010037045.generationsgaither.com"
    }







  

    :local setupFileFrom do={
        :local server
        :local serverType 
        :local loginRequired 
        :local loginName 
        :local loginPassword
        :local downloadFile
        :local destinationFile
        
        :local setupFileFromHasError "false"
        :local cont
        :while ($setupFileFromHasError = "false") do={
            :if ($serverType = "ftp" and $loginRequired = "true") do={
                # Download latest the latest copy of the Mikrotik Management Script .rsc file
                /tool fetch address="$server" src-path="/$downloadFile" user="$loginName" mode=ftp password="$loginPassword" dst-path="$destinationFile"
                :log info "Downloading Mikrotik Management Scripts control script MMS-InstallScripts.rsc downloading"
                :delay 5
                :if ([:len [/file find name="$destinationFile"]] > 0) do={
                    :local cont [/file get $destinationFile contents]
                    :set $destinationFileVersion [$getVersion fileContent="$cont"]
                    :set $destinationFileScriptName [$getScriptName fileContent="$cont"]                    
                } else={
                    :log info "$destinationFile does not exist"
                    :return $setupFileFromHasError
                }
                :if ([ :len [ /system/script/find where name="$destinationFileScriptName" ] ] = 0) do={
                    :log info "Script $destinationFileScriptName does not exist, creating script"
                    /system/script add name="$destinationFileScriptName" owner=admin source=$cont
                    # Implement Later
                    # /system script run installScripts
                } else={
                    :set $cont [ /system/script/get [/system/script find where name=$destinationFileScriptName] source]
                    :set $storedScriptVersion [$getFileVersion filecontent="$cont"]
                }
            }
            :if ($serverType = "http" and $loginRequired = "false") do={
                # Download latest the latest copy of the Mikrotik Management Script .rsc file
                /tool fetch address="$server" src-path="/$downloadFile" mode=ftp dst-path="$destinationFile"
                :log info "Downloading Mikrotik Management Scripts control script MMS-InstallScripts.rsc downloading"
                :delay 5
                :if ([:len [/file find name="$destinationFilename"]] > 0) do={
                    :local cont [/file get $destinationFilename contents]
                    :set $destinationFileVersion [$getVersion fileContent="$cont"]
                } else={
                    :log info "$destinationFile does not exist"
                    :return $setupFileFromHasError
                }
            }
        }
    }

    # Setup and Schedule Scripts on Mikrotik devices
    :global setupScript do={
        # Set error catch variable setupScriptHasErrors to false, Exit if setupScriptHasErrors is true
        :local setupScriptHasErrors "false"
        :while ($SetupScriptHasErrors = "false") do={
            # Default global ftp server variable
            :global ftpScriptServer
            # Download server fqdn or iternet potocol address
            :local downloadServername
            :if ([:len $downloadServername] = 0) do={
                $downloadServername = "$ftpScriptServer"
                $downloadServerType = "ftp"
            }
            # default download server type (default ftp, not implemented yet http, https, ssh)
            :local downloadServerType
            :if ([:len $downloadServerType] = 0) do={
                $downloadServerType = "ftp"
            }
            # Name of file to download from server
            :local downloadFilename
            :if ([:len $downloadFilename] = 0) do={
                :log Info "No download filename was provides in funtion scriptSetup"
                :set $downloadHasErrors "true"
            }
            # Name of temporary file to be stored on Mikrotik device
            :local destinationFilename
            :if ([:len $destinationFilename] = 0) do={
                $destinationFilename = $downloadFilename
            }
            # Version Number of the downloaded file
            :local destinationFileVersion
            # Are login credentials required to download file
            :local downloadLoginRequired "true"
            # Login name for the download server 
            :local downloadLoginName
            # Login password for login name (should be stored in /ppp/secrets)
            :local downloadLoginPassword
            :local noPassword "false"
            :if ($downloadLoginRequired = "true") do={
                :if ([:len $downloadLoginName] = 0) do={
                    :set $downloadLoginName "MikrotikScripts"
                    :set $downloadLoginPassword [$getPasswordFromPPP name= $downloadLoginName
                    :set $downloadLoginPassword [/ppp secret get [/ppp secret find name=$downloadLoginName] password]
                    :if ([:len $downloadLoginPassword ] = 0 ) do={
                        :log info "Password retreival failed for $downloadLoginName exiting funtion SetupScript"
                        :set $noPassword "true"
                    } else={
                        :log info "Password retreival succeded for $downloadLoginName exiting funtion SetupScript"
                        :set $noPassword "true"
                    }
                } else={
                    :if ([:len $downloadLoginPassword] = 0 ) do={
                        :set downloadLoginPassword [/ppp secret get [/ppp secret find name=$downloadLoginName] password]
                        :if ([:len $downloadLoginPassword] = 0 ) do={
                            :log "Password is required but not supplied"
                            :set $hasErrors "true"
                        }
                    }
                    :if ($downloadServerType = "ftp") do={

                    }
                    :if ($downloadServerType = "http") do={
                    }
                    :if ($downloadServerType = "https") do={
                    }
                    :if ($downloadServerType = "ssh") do={
                    } else={
                        :log info "No Type of download server specified (e.g. ftp, http, https)"
                    } 
                }
            } else={

            }
        }
        # Name of the script to be stored in Mikrotik device        
    }
        
        :if ($hasErrors = "false") do={
            # Download latest the latest copy of the Mikrotik Management Script .rsc file"
            /tool fetch address="$dlServername" src-path="/$dsFilename" user="MikrotikScripts" mode=ftp password="$mikrotikScriptsFTPPassword" dst-path="MMS-InstallScripts.rsc" 
            :log info "Downloading Mikrotik Management Scripts control script MMS-InstallScripts.rsc downloading"
            :delay 5
            # Get MMS-InstallSripts.rsc file Version"
            :put [:len [/file find name="$dsFilename"]]
            
            :if ([ :len [ /system/script/find where name="$dsFilename" ] ] = 0) do={
                :log info "Script $dsFilename does not exist, creating script"
                /system/script add name="$dsFilename" owner=admin source=$cont
                # Implement Later
                # /system script run installScripts
            } else={
                # Get stored script MMS-InstallSripts file Version"
                :set $cont [ /system/script/get [/system/script find where name=$dsFilename] source]
                :local scriptVersion [:pick $cont 11 23]
                :if ($fileVersion>$scriptVersion) do={
                    /system script set [find name=$dsFilename] source=$cont
                    :log info "Mikrotik Management Script $dsFilename was updated to version $fileVersion from version $scriptVersion"
                    :delay 5
                } else={
                    :log info "Mikrotik Management Script $dsFilename is already the newest version No update is required"
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
    }
    }
    # Script file version
    :global getFileVersion

    :global getStoredScriptVersion






}