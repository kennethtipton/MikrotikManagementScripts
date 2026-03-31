# Version: 202504071112
# Script Name: MMS-getScriptName
# Script file created by Kenneth Tipton
# Telecommunications Networking and Computing, Inc.
#
# Get the stored script name from the header of an script file (.rsc)
# example: :set $scriptName [$getScriptName]
{
    # Function - Get the Stored Script Name from Script file
    # $getScriptName fileContent="Content of file"
    :local getScriptName do={
        :local scriptName "Unkown"
        :if ([:len $fileContent] > 0) do={
            :local l ([:find $fileContent "MMS-"])
            :set $scriptName [:pick $fileContent $l ([:find [:pick $fileContent $l 75] "#"] + $l)]
        }
        :return $scriptName
    }
}