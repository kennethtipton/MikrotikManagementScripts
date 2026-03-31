{
    # Script Name: listPPPSecrets.rsc
    # Description: Lists all PPP secret names, comments, and passwords.
    # Author: Kenneth G. Tipton
    # Date: 2026-03-31

    ## Usage: :global listPPPSecrets; $listPPPSecrets "optionalName"

    :global listPPPSecrets do={
        :local filterName "mikrotikscripts"
        :if ([:len $1] > 0) do={
            :set filterName $1
        }

        :foreach s in=[/ppp secret find] do={
            :local name [/ppp secret get $s name]
            :if ([:len $filterName] = 0 || $name = $filterName) do={
                :local comment [/ppp secret get $s comment]
                :local password [/ppp secret get $s password]
                :put ("$name\t$comment\t$password")
            }
        }
    }

    # Function: downloadDataSetMaps
    # Uses PPP secret (name, comment=server, password) to fetch all /dataSetMaps/dataSetMap* files from FTP

    :global downloadDataSetMaps do={
        :local user "mikrotikscripts"
        :if ([:len $1] > 0) do={
            :set user $1
        }
        :local foundId [/ppp secret find name=$user]
        :if ([:len $foundId] = 0) do={
            :put ("ERROR: PPP secret '" . $user . "' not found.")
            :error "PPP secret not found"
        }
        :local id [:pick $foundId 0]
        :local server [/ppp secret get $id comment]
        :local password [/ppp secret get $id password]
        :local ftpPath "/dataSetMaps/"
        :put ("Fetching dataSetMap* from FTP server: " . $server)
        /tool fetch \
            address=$server \
            user=$user \
            password=$password \
            src-path=("$ftpPath" . "dataSetMap*") \
            mode=ftp \
            keep-result=yes
        :log info ("downloadDataSetMaps: Complete for user '" . $user . "' from server '" . $server . "'.")
    }
    $downloadDataSetMaps
}
