# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260405131620
# Script Filename: dataSetMapRequiredMMSFunctions.rsc
# Stored Script Name: dataSetMapRequiredMMSFunctions
# Description: Dataset map of required MMS function script files.
# Author: Kenneth G. Tipton
# Date: 2026-04-05
# Time: 13:16:20
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
:global dataSetMapRequiredMMSFunctions [:toarray ""]
:set ($dataSetMapRequiredMMSFunctions->"FUNC001") "MMS-getFtpServerNameFromPPP.rsc"
:set ($dataSetMapRequiredMMSFunctions->"FUNC002") "MMS-importStoredScriptsFromFiles.rsc"
:set ($dataSetMapRequiredMMSFunctions->"FUNC003") "MMS-InitializeVariables.rsc"
:set ($dataSetMapRequiredMMSFunctions->"FUNC004") "MMS-downloadFileFromFTP.rsc"
:set ($dataSetMapRequiredMMSFunctions->"FUNC005") "MMS-removeFile.rsc"
:set ($dataSetMapRequiredMMSFunctions->"FUNC006") "MMS-dataSetMapSync.rsc"
