# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260403154154
# Script Filename: MMS-BackupToFTP.rsc
# Stored Script Name: MMS-SBackupToFTP
# Description: Used to create two backup files of device and store on ftp server.
# Author: Kenneth G. Tipton
# Date: 2026-04-03
# Time: 15:41:54
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    # Startup
    :log info "Starting Automatic Backup Script"
    :log info "Removing Old Backup Files"

    # Script constants
    :log info "Seting Backup Scripts Constants"
    :global deviceHostname
    :global deviceIPDesinator
    :global ftpBackupServer

    :local ftpUser $deviceHostname
    :local ftpPassword [/ppp secret get [/ppp secret find name=$ftpUser] password]
    :local certificatePassphrase [/ppp secret get [/ppp secret find name="certificatePassword"] password]
    :local certType "pkcs12"
    :local thisDate [/system clock get date]
    :local thisTime [/system clock get time]
    :local dateTimeString ([:pick $thisDate 0 4] . [:pick $thisDate 5 7] . [:pick $thisDate 8 12])
    :local timeTimeString ([:pick $thisTime 0 2] . [:pick $thisTime 3 5] . [:pick $thisTime 6 8])
    :local backupFileName ("BACKUP-" . $deviceHostname . "-" . $dateTimeString . "-" . $timeTimeString)

    :local scriptFile ($backupFileName . ".rsc")
    :local backupFile ($backupFileName . ".backup")

    # Create local backup files
    :log info "Exporting Restore Script to $backupFileName"
    /export file=$backupFileName show-sensitive
    :delay 5s

    :log info "Saving Backup file to $backupFileName"
    /system backup save name=$backupFileName
    :delay 5s

    # Export local certificates
    :log info "Backup of Local Certificates"
    :foreach certId in=[/certificate find] do={
        :local certName [/certificate get $certId name]
        /certificate export-certificate [find name=$certName] export-passphrase=$certificatePassphrase type=$certType
    }

    # Upload backup files
    /tool fetch \
        address=$ftpBackupServer \
        src-path=$scriptFile \
        user=$ftpUser \
        mode=ftp \
        password=$ftpPassword \
        dst-path=("/" . $scriptFile) \
        upload=yes
    :delay 10

    /tool fetch \
        address=$ftpBackupServer \
        src-path=$backupFile \
        user=$ftpUser \
        mode=ftp \
        password=$ftpPassword \
        dst-path=("/" . $backupFile) \
        upload=yes
    :delay 10

    # Remove local backup files
    :if ([:len [/file find name="$backupFile"]]) do={
        /file remove [find name="$backupFile"]
    }

    :if ([:len [/file find name="$scriptFile"]]) do={
        /file remove [find name="$scriptFile"]
    }
}
