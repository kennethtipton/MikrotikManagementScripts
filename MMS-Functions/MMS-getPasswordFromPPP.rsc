# Version: 202504071112
# Script Name: MMS-getPasswordFromPPP
# Script file created by Kenneth Tipton
# Telecommunications Networking and Computing, Inc.
#
# Get the Password stored in Mikrotik /ppp/secrets
# example: first store name and password "/ppp/secrets add name=MikrotikScripts password="Something Secret"
# then use :set $password [$getPasswordFromPPP name="MikrotikScripts"] to retreive password
{
    :local getPasswordFromPPP do={
        :local exitGetPasswordFromPPP false
        :local temporaryName
        :local passwordFound true
        :local pppPassword
        :if ([:len $name] > 0) do={
            :set $temporaryName $name
            :put "Here I am "
            :delay 5
        } else={
            :set $temporaryName "mikrotikscripts"
            :put "Here we are"
            :delay 5
        }
        :do {
            :set $temporaryPassword [/ppp secret get [/ppp secret find name=$temporaryName] password]
        } on-error={ 
            :set $passwordFound false
        }
        :if ($passwordFound = true) do={
            :set $pppPassword $tempPassword
            :put $temporaryPassword
            :put $pppPassword
            :log info "Password retreival SUCCEEDED for /ppp/secret name $temporaryName, exiting funtion getPasswordFromPPP"
            :return $tempPassword
        } else={
            :log warning "Password retreival FAILED for /ppp/secret name $temporaryName, exiting funtion getPasswordFromPPP"
            :log warning "Check for $temporaryName in /ppp secrets"
            :return "failed"
        }
    }
    #:set $password [$getPasswordFromPPP name="MikrotikScripts"]
    #:set $password [$getPasswordFromPPP name="kennethtipton"]
    :set $password [$getPasswordFromPPP]
    :put $password
}
