# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260407130126
# Script Filename: dataSetMapFileManifest.rsc
# Stored Script Name: dataSetMapFileManifest
# Description: Dataset map of dataSetMap files to be synced to the device by MMS-dataSetMapSync.
# Author: Kenneth G. Tipton
# Date: 2026-04-07
# Time: 13:01:26
# used AI tools: GitHub Copilot (GPT-5.4)
# ===================================================================
:global dataSetMapFileManifest [:toarray ""]
:set ($dataSetMapFileManifest->"FILE001") "dataSetMapDeviceLocationAtSite.rsc"
:set ($dataSetMapFileManifest->"FILE002") "dataSetMapDeviceType.rsc"
:set ($dataSetMapFileManifest->"FILE003") "dataSetMapLocationBaseSubnetCidr.rsc"
:set ($dataSetMapFileManifest->"FILE004") "dataSetMapCompanyAbbreviation.rsc"
:set ($dataSetMapFileManifest->"FILE005") "dataSetMapRequiredMMSFunctions.rsc"
:set ($dataSetMapFileManifest->"FILE006") "dataSetMapDeviceBackupPassword.rsc"
:set ($dataSetMapFileManifest->"FILE007") "dataSetMapPSKWirelessSecurityProfiles.rsc"
