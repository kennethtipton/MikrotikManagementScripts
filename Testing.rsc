# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260403154154
# Script Filename: Testing.rsc
# Stored Script Name: Testing
# Description: Utility test script for validating script header parsing and fetch behavior.
# Author: Kenneth G. Tipton
# Date: 2026-04-03
# Time: 15:41:54
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    :global getHeaderValue
    :local mikrotikScriptsFTPPassword  [/ppp secret get [/ppp secret find name="MikrotikScripts"] password]
    /tool fetch address="srv010010037045.generationsgaither.com" src-path="/MMS-SetupMgmtScript.rsc" user="MikrotikScripts" mode=ftp password="$mikrotikScriptsFTPPassword" dst-path="MMS-SetupMgmtScript.rsc" 
    :log info "Downloading Mikrotik Management Scripts control script MMS-InstallScripts.rsc downloading"
    :delay 5
    :local cont [/file get MMS-SetupMgmtScript.rsc contents]

     :put [$getHeaderValue $cont "# Script Name:"]
}



