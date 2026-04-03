# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260403154154
# Script Filename: dataSetMapFileManifest.rsc
# Stored Script Name: dataSetMapFileManifest
# Description: Dataset map of dataSetMap files to be synced to the device by MMS-dataSetMapSync.
# Author: Kenneth G. Tipton
# Date: 2026-04-03
# Time: 15:41:54
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
:global dataSetMapFileManifest [:toarray ""]
:set ($dataSetMapFileManifest->"FILE001") "dataSetMapDeviceLocationAtSite.rsc"
:set ($dataSetMapFileManifest->"FILE002") "dataSetMapDeviceType.rsc"
:set ($dataSetMapFileManifest->"FILE003") "dataSetMapLocationBase.rsc"
:set ($dataSetMapFileManifest->"FILE004") "dataSetMapCompanyAbbreviation.rsc"
:set ($dataSetMapFileManifest->"FILE005") "dataSetMapPSKWirelessSecurityProfiles.rsc"
