# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260407125240
# Script Filename: dataSetMapLocationBaseSubnetCidr.rsc
# Stored Script Name: dataSetMapLocationBaseSubnetCidr
# Description: Dataset map of CIDR subnet key to fully qualified base site location name.
# Author: Kenneth G. Tipton
# Date: 2026-04-07
# Time: 12:52:40
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
:global dataSetMapLocationBaseSubnetCidr [:toarray ""]
:set ($dataSetMapLocationBaseSubnetCidr->"10.5.0.0/16") "GGI.TN.PTP_VPN"
:set ($dataSetMapLocationBaseSubnetCidr->"10.15.0.0/16") "GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.35.0/24") "GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET.GYM-GARAGE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.36.0/24") "GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET.ADMINISTRATION_BUILDING_I"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.37.0/24") "GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.38.0/24") "GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET.ADMINISTRATION_BUILDING_I"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.39.0/24") "GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET.ADMINISTRATION_BUILDING_I"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.40.0/24") "GGI.TN.COOKEVILLE.FACILITY.LOGAN_HOUSE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.41.0/24") "GGI.TN.WOODBURY.CAMPUS-AUBURNTOWN_ROAD.WARREN_HOUSE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.42.0/24") "GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET.ADMINISTRATION_BUILDING_II"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.43.0/24") "GGI.TN.SPENCER.FACILITY.GENERATIONS_OF_SPENCER"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.44.0/24") "GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET.ROBERT_COY_HOUSE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.46.0/24") "MSHN.TN.MEMPHIS.FACILITY.MSHN_HOUSE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.47.0/24") "GGI.TN.COOKEVILLE.FACILITY.MENTAL_HEALTH_CENTER"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.48.0/24") "GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD.KOLTON_WAYNE_HOUSE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.49.0/24") "GGI.TN.DRESDEN.FACILITY.MENTAL_HEALTH_CENTER"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.50.0/24") "GGI.TN.MORRISON.FACILITY.MENTAL_HEALTH_CENTER"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.51.0/24") "GGI.TN.COOKEVILLE.FACILITY.SKYLAR_HOUSE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.52.0/24") "GGI.TN.DRESDEN.OFFICE.CARE_MANAGERS_OFFICE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.53.0/24") "GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD.CAMPBELL_LODGE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.54.0/24") "GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD.ELLA_KATELYN_HOUSE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.56.0/24") "GGI.TN.WOODBURY.CAMPUS-AUBURNTOWN_ROAD.HARWELL_HOUSE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.57.0/24") "GGI.TN.MCMINNVILLE.FACILITY.WOODLEE_TRAIL_HOUSE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.58.0/24") "GGI.TN.CENTERTOWN.CAMPUS-OLD_NASHVILLE_HIGHWAY_AND_CRISP_SPRINGS_ROAD.KRISTOPHER_WYANE_HOUSE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.59.0/24") "GGI.TN.DAYTON.FACILITY.MENTAL_HEALTH_CENTER"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.60.0/24") "GGI.TN.MORRISON.CAMPUS-SUNY_ACRES_ROAD.DENTON_HOUSE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.61.0/24") "GGI.TN.MORRISON.CAMPUS-SUNY_ACRES_ROAD.JAME_GILBERT_HOUSE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.62.0/24") "GGI.TN.MORRISON.CAMPUS-SUNY_ACRES_ROAD.WOOD_HOUSE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.64.0/24") "GGI.TN.BAXTER.HOME_OFFICE.SHELIA_PALMER"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.65.0/24") "GGI.TN.MCMINNVILLE.HOME_OFFICE.ANGILA_REDWINE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.66.0/24") "GGI.TN.MCMINNVILLE.HOME_OFFICE.WAYNE_GREER"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.67.0/24") "GGI.KY.MIDDLESBORO.FACILITY.GENERATIONS_OF_MIDDLESBORO"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.68.0/24") "GGI.TN.MCMINNVILLE.HOME_OFFICE.BUFFY_GAITHER"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.69.0/24") "GGI.TN.MCMINNVILLE.HOME_OFFICE.TRESIA_CRIPPS"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.190.0/24") "MTPC.TN.COOKEVILLE.OFFICE.CORPORATE"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.200.0/24") "TNC.TN.MCMINNVILLE.HOME_OFFICE.KENNETH_TIPTON_I"
:set ($dataSetMapLocationBaseSubnetCidr->"10.10.201.0/24") "TNC.TN.MCMINNVILLE.HOME_OFFICE.KENNETH_TIPTON_II"
:set ($dataSetMapLocationBaseSubnetCidr->"69.8.161.136/29") "GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET.ADMINISTRATION_BUILDING_I"
:set ($dataSetMapLocationBaseSubnetCidr->"47.49.224.232/29") "GGI.TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET.ADMINISTRATION_BUILDING_I"
:set ($dataSetMapLocationBaseSubnetCidr->"192.131.57.184/29") "GGI.TN.MORRISON.FACILITY.MENTAL_HEALTH_CENTER"
:set ($dataSetMapLocationBaseSubnetCidr->"47.49.231.40/29") "GGI.TN.MORRISON.FACILITY.MENTAL_HEALTH_CENTER"