# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
#
# Script Version: 20260403154154
# Script Filename: MMS-radius.rsc
# Stored Script Name: MMS-radius
# Description: Adds the primary RADIUS server used for wireless authentication.
# Author: Kenneth G. Tipton
# Date: 2026-04-03
# Time: 15:41:54
# used AI tools: GitHub Copilot (GPT-5.3-Codex)
# ===================================================================
{
    /radius
    add address=10.10.38.39 require-message-auth=no secret=4GGIuse0nly. service=\
        wireless src-address=10.10.37.7 timeout=4s
}
