# MikroTik Management Scripts
# MMS Version: 0.01 Testing
{
    # MMS Version: 0.01
    # Script Version: 202604031030
    # Script Name: MMS-removeFile
    # Description: Removes a file from the MikroTik device by name or path.
    # Author: Kenneth G. Tipton
    # Date: 2026-04-03

    # Generic function to remove a file from the MikroTik device by name/path.
    # Usage:
    #   /import file-name=MMS-removeFile.rsc
    #   :global MMSremoveFile
    #   $MMS-removeFile "dataSets/dataSetMapPSKWirelessSecurityProfiles.rsc"
    # Optional second argument (strict):
    #   $MMSremoveFile "fileName" "true"
    # If strict is true, throws an error when no file is found.
    :global MMSremoveFile do={
        :local fileName [:tostr $1]
        :local strict "false"
        :if ([:len [:tostr $2]] > 0) do={
            :set strict [:tostr $2]
        }

        :if ([:len $fileName] = 0) do={
            :if ($strict = "true") do={
                :error "MMSremoveFile: fileName is required"
            }
            :return "false"
        }

        :local ids [/file find name=$fileName]
        :if ([:len $ids] = 0) do={
            :if ($strict = "true") do={
                :error ("MMSremoveFile: File not found: " . $fileName)
            }
            :return "false"
        }

        :foreach id in=$ids do={
            /file remove $id
        }

        :return "true"
    }
}
