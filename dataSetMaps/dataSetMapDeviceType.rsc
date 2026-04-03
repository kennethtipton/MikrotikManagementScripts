# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260403154154
# Script Filename: dataSetMapDeviceType.rsc
# Stored Script Name: dataSetMapDeviceType
# Description: Dataset map of 3-letter hostname designators to normalized device types.
# Author: Kenneth G. Tipton
# Date: 2026-04-03
# Time: 15:41:54
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
:global dataSetMapDeviceType [:toarray ""]
:set ($dataSetMapDeviceType->"acp") "ACCESS_POINT"
:set ($dataSetMapDeviceType->"grt") "GATEWAY_ROUTER"
:set ($dataSetMapDeviceType->"rtr") "ROUTER"
:set ($dataSetMapDeviceType->"wrt") "WIRELESS_ROUTER"
:set ($dataSetMapDeviceType->"swh") "SWITCH"
