{
    :local getScriptName do={
        :local scriptName "Unkown"
        :if ([:len $fileContent] > 0) do={
            :local l ([:find $fileContent "MMS-"])
            :set $scriptName [:pick $fileContent $l ([:find [:pick $fileContent $l 75] "#"] + $l)]
        }
        :return $scriptName
    }
    :local mikrotikScriptsFTPPassword  [/ppp secret get [/ppp secret find name="MikrotikScripts"] password]
    /tool fetch address="srv010010037045.generationsgaither.com" src-path="/MMS-SetupMgmtScript.rsc" user="MikrotikScripts" mode=ftp password="$mikrotikScriptsFTPPassword" dst-path="MMS-SetupMgmtScript.rsc" 
    :log info "Downloading Mikrotik Management Scripts control script MMS-InstallScripts.rsc downloading"
    :delay 5
    :local cont [/file get MMS-SetupMgmtScript.rsc contents]

     :put [$getScriptName fileContent=$cont]
}



