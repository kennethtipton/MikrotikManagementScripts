# Version: 202504071112
# Script Name: MMS-getVersion
# Script file created by Kenneth Tipton
# Telecommunications Networking and Computing, Inc.
#
# Get the script version from header of script file (.rsc() or stored script
# example: :set $scriptVersion [$getVersion]
{
    # Function used to get the verions of a script file (.rsc) or stored script 
    :Local getVersion do={
        :local version 999999999999
        :if ([:len $fileContent] > 0) do={
            :set $version [:pick $fileContent 11 23]
        }
        :return $version
    }
}