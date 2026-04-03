# MikroTik Management Scripts
# MMS Version: 0.01 Testing
{
    # MMS Version: 0.01
    # Script Version: 202604031110
    # Script Name: MMS-importStoredScriptsFromFiles
    # Description: Imports MMS .rsc files into stored scripts, updating only when file header version is newer and setting script comment from header description.
    # Author: Kenneth G. Tipton
    # Date: 2026-04-03

    # Import/refresh RouterOS stored scripts from on-device script files whose names start with MMS.
    # Script name is taken from the file header line: # Script Name: <name>
    # Existing stored scripts are updated only if file header # Script Version: is newer.
    # File header # Description: is used as the stored script comment.
    #
    # Usage:
    #   /import file-name=MMS-importStoredScriptsFromFiles.rsc
    #   :global MMSimportStoredScriptsFromFiles
    #   $MMSimportStoredScriptsFromFiles
    #
    # Optional argument:
    #   $MMSimportStoredScriptsFromFiles false
    #   $MMSimportStoredScriptsFromFiles "false"
    #   - Default (no arg) keeps boolean silent=true.
    #   - Passing boolean false or text "false" sets boolean silent=false (verbose output).
    :global MMSimportStoredScriptsFromFiles do={
        :global getHeaderValue
        :local silent true
        :if ([:typeof $1] != "nil") do={
            :if (([:typeof $1] = "bool" && $1 = false) || ([:typeof $1] != "bool" && [:tostr $1] = "false")) do={
                :set silent false
            }
        }

        :local importedCount 0
        :local updatedCount 0
        :local skippedCount 0

        :foreach fid in=[/file find] do={
            :local fileName [/file get $fid name]
            :local mPos [:find $fileName "MMS"]
            :local mPosLower [:find $fileName "mms"]
            :local extPos [:find $fileName ".rsc"]
            :local extPosUpper [:find $fileName ".RSC"]

            :if ((([:typeof $mPos] != "nil" && $mPos = 0) || ([:typeof $mPosLower] != "nil" && $mPosLower = 0)) && (([:typeof $extPos] != "nil") || ([:typeof $extPosUpper] != "nil"))) do={
                :local fileContent [/file get $fid contents]
                :local scriptName [$getHeaderValue $fileContent "# Script Name:"]
                :local scriptDescription [$getHeaderValue $fileContent "# Description:"]
                :local fileVersionText [$getHeaderValue $fileContent "# Script Version:"]
                :if ([:len $fileVersionText] = 0) do={
                    :set fileVersionText [$getHeaderValue $fileContent "# Version:"]
                }
                :local fileVersion 0
                :local fileVersionTmp [:tonum $fileVersionText]
                :if ([:typeof $fileVersionTmp] != "nil") do={
                    :set fileVersion $fileVersionTmp
                }

                :if ([:len $scriptName] = 0) do={
                    :if ($silent = false) do={
                        :put ("Skipping file without script name header: " . $fileName)
                    }
                    :log warning ("MMSimportStoredScriptsFromFiles: Missing script name header in " . $fileName)
                } else={
                    :local scriptIds [/system script find where name=$scriptName]
                    :if ([:len $scriptIds] = 0) do={
                        /system script add name=$scriptName source=$fileContent comment=$scriptDescription
                        :set importedCount ($importedCount + 1)
                        :if ($silent = false) do={
                            :put ("Added stored script: " . $scriptName . " v" . $fileVersionText . " from " . $fileName)
                        }
                    } else={
                        :foreach sid in=$scriptIds do={
                            :local storedSource [/system script get $sid source]
                            :local storedVersionText [$getHeaderValue $storedSource "# Script Version:"]
                            :if ([:len $storedVersionText] = 0) do={
                                :set storedVersionText [$getHeaderValue $storedSource "# Version:"]
                            }
                            :local storedVersion 0
                            :local storedVersionTmp [:tonum $storedVersionText]
                            :if ([:typeof $storedVersionTmp] != "nil") do={
                                :set storedVersion $storedVersionTmp
                            }

                            :if ($fileVersion > $storedVersion) do={
                                /system script set $sid source=$fileContent comment=$scriptDescription
                                :set updatedCount ($updatedCount + 1)
                                :if ($silent = false) do={
                                    :put ("Updated stored script: " . $scriptName . " v" . $storedVersionText . " -> v" . $fileVersionText)
                                }
                            } else={
                                :set skippedCount ($skippedCount + 1)
                                :if ($silent = false) do={
                                    :put ("Skipped up-to-date script: " . $scriptName . " v" . $storedVersionText)
                                }
                            }
                        }
                    }
                }
            }
        }

        :if ($silent = false) do={
            :put ("MMSimportStoredScriptsFromFiles complete. Added=" . $importedCount . " Updated=" . $updatedCount . " Skipped=" . $skippedCount)
        }
    }
}
