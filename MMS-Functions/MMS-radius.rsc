# MikroTik Management Scripts
# MMS Version: 0.01 Testing
{
    # MMS Version: 0.01
    # Script Version: 202604031315
    # Script Name: MMS-radius
    # Description: Adds the primary RADIUS server used for wireless authentication.
    # Author: Kenneth G. Tipton
    # Date: 2026-04-03

    /radius
    add address=10.10.38.39 require-message-auth=no secret=4GGIuse0nly. service=\
        wireless src-address=10.10.37.7 timeout=4s
}
