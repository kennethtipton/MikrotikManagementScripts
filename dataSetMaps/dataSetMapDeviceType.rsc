# MikroTik Management Scripts
# MMS Version: 0.01 Testing
# Script Name: dataSetMapDeviceType.rsc
# Description: Dataset map of 3-letter hostname designators to normalized device types.
# Author: Kenneth G. Tipton
# Date: 2026-04-02
# Version: 202604021513

:global dataSetMapDeviceType [:toarray ""]
:set ($dataSetMapDeviceType->"acp") "ACCESS_POINT"
:set ($dataSetMapDeviceType->"grt") "GATEWAY_ROUTER"
:set ($dataSetMapDeviceType->"rtr") "ROUTER"
:set ($dataSetMapDeviceType->"wrt") "WIRELESS_ROUTER"
:set ($dataSetMapDeviceType->"swh") "SWITCH"
