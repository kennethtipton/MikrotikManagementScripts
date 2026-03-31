# Version: 202504021153              
# Script Name: MMS-SBackupToFTP
# Script file created by Kenneth Tipton
# Telecommunications Networking and Computing, Inc.
#
# Used to create two backup files of device and store on ftp server
# Also used to backup device certificates
{
    # Remove Old Backup Files
    :log info "Starting Automatic Backup Script"
    :log info "Removing Old Backup Files"

    :log info "Seting Backup Scripts Constants"
    :global deviceHostname
    :global deviceIPDesinator
    :global ftpBackupServer
    :local serverport 21
    :local ftpuser $deviceHostname
    # Get Password stored in /ppp secrets
    :local ftpPassword [/ppp secret get [/ppp secret find name=$ftpuser] password]
    :local certificatePassphrase  [/ppp secret get [/ppp secret find name="certificatePassword"] password]
    :local certtype "pkcs12"
    :local thisdate [/system clock get date]
    :local thistime [/system clock get time]
    :local datetimestring ([:pick $thisdate 0 4] . [:pick $thisdate 5 7] . [:pick $thisdate 8 12])
    :local timetimestring ([:pick $thistime 0 2] . [:pick $thistime 3 5] . [:pick $thistime 6 8])
    :local backupfilename ("BACKUP-".$deviceHostname."-".$datetimestring."-".$timetimestring)

    :local scriptFile ("$backupfilename.rsc")
    :local backupFile ("$backupfilename.backup")
    
    # Create a local copy of restore script file
    :log info "Exporting Restore Script to $backupfilename"
    /export file=$backupfilename show-sensitive
    :delay 5s
    # Create a local copy of Mikrotik backup file
    :log info "Saving Backup file to $backupfilename"
    /system backup save name=("$backupfilename")
    :delay 5s
    
    :log info "Backup of Local Certificates"
    :foreach certname in=[/certificate find] do={
        :local name [/certificate get $certname name]
        :do { /certificate export-certificate [find name=$"name"] export-passphrase="$passphrase" type="$certtype" }
    }

    # Store System configuration on ftp server
    /tool fetch address=$ftpBackupServer src-path=$scriptFile user=$ftpuser mode=ftp password=$ftpPassword dst-path="/$scriptFile" upload=yes
    :delay 10
    /tool fetch address=$ftpBackupServer src-path=$backupFile user=$ftpuser mode=ftp password=$ftpPassword dst-path="/$backupFile" upload=yes
    :delay 10
    # Remove local copy of restore script file
    :if ([:len [/file find name="$backupFile"]]) do={
        /file remove [find name="$backupFile"]
    }
    # Remove local copy of backup file
    :if ([:len [/file find name="$scriptFile"]]) do={
        /file remove [find name="$scriptFile"]
    }

}
