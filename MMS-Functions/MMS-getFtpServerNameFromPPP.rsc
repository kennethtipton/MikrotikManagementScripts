# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260403160430
# Script Filename: MMS-getFtpServerNameFromPPP.rsc
# Stored Script Name: MMS-getFtpServerNameFromPPP
# Description: Retrieves the FTP server FQDN from a MikroTik PPP secret comment by name.
# Author: Kenneth G. Tipton
# Date: 2026-04-03
# Time: 16:04:30
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    # Get the FTP server name stored in a MikroTik /ppp secret comment.
    # Example: :set $ftpServer [$getFtpServerNameFromPPP "BKP010010048007"]
    :global getFtpServerNameFromPPP do={
        :local secretName "mikrotikscripts"
        :local ftpServerName ""
        :local secretFound true

        :if ([:len $1] > 0) do={
            :set secretName $1
        }

        :do {
            :set ftpServerName [/ppp secret get [/ppp secret find name=$secretName] comment]
        } on-error={
            :set secretFound false
        }

        :if ($secretFound = true && [:len $ftpServerName] > 0) do={
            :log info ("FTP server retrieval SUCCEEDED for /ppp secret name " . $secretName)
            :return $ftpServerName
        }

        :log warning ("FTP server retrieval FAILED for /ppp secret name " . $secretName)
        :log warning ("Check for " . $secretName . " in /ppp secrets and confirm comment contains the FTP server FQDN")
        :return "failed"
    }
}