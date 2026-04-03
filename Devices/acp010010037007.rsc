# MikroTik Management Scripts
# MMS Version: 0.01 Testing
# 2025-07-11 10:40:26 by RouterOS 7.19.3
# software id = PY7C-J2IS
#
# model = RBcAPGi-5acD2nD
# serial number = B9330B0D70C6
/caps-man configuration
add country="united states3" distance=indoors installation=indoor mode=ap \
    name=GHA ssid=GHA
/interface bridge
add name=BRDG-GGI-037007-010010037007-24 port-cost-mode=short
add name=BRDG-GGI-037007-192168037007-32 port-cost-mode=short protocol-mode=\
    none
/interface ethernet
set [ find default-name=ether1 ] name=BRDG-GGI-037007-010010037007-24-EHT01
set [ find default-name=ether2 ] name=BRDG-GGI-037007-010010037007-24-ETH02
/interface list
add name=INF-BFD
/interface lte apn
set [ find default=yes ] ip-type=ipv4 use-network-apn=no
/interface wireless interworking-profiles
add domain-names=generationsgaither.com ipv4-availability=single-nated name=\
    CorporateOffices network-type=private roaming-ois="" venue=\
    business-professional-office venue-names=GenerationsCorporateOffices
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
add authentication-types=wpa-psk,wpa2-psk eap-methods="" \
    management-protection=allowed mode=dynamic-keys name=GGI-256 \
    supplicant-identity="" wpa-pre-shared-key=4GGIaccess. \
    wpa2-pre-shared-key=4GGIaccess.
add authentication-types=wpa-psk,wpa2-psk mode=dynamic-keys name=GGI-TC \
    supplicant-identity="" wpa-pre-shared-key=Dollars&C3nts. \
    wpa2-pre-shared-key=Dollars&C3nts.
add authentication-types=wpa-eap,wpa2-eap mode=dynamic-keys name=GHA \
    supplicant-identity="" tls-mode=dont-verify-certificate
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=20/40mhz-XX \
    disabled=no frequency=auto installation=indoor mode=ap-bridge name=\
    BRDG-GGI-037007-010010037007-24-W2G01 radio-name=ACP010010037007-2G \
    security-profile=GGI-256 ssid=GGI station-roaming=enabled \
    wireless-protocol=802.11 wmm-support=enabled wps-mode=disabled
add disabled=no keepalive-frames=disabled mac-address=C6:AD:34:32:41:BF \
    master-interface=BRDG-GGI-037007-010010037007-24-W2G01 \
    multicast-buffering=disabled name=BRDG-GGI-037007-010010037007-24-W2G03 \
    security-profile=GGI-TC ssid=GGI-TC wds-cost-range=1 wds-default-cost=1 \
    wps-mode=disabled
add disabled=no keepalive-frames=disabled mac-address=C6:AD:34:32:41:C1 \
    master-interface=BRDG-GGI-037007-010010037007-24-W2G01 max-station-count=\
    200 multicast-buffering=disabled name=\
    BRDG-GGI-037007-010010037007-24-W2G10 security-profile=GHA ssid=GHA \
    wds-cost-range=1 wds-default-cost=1 wmm-support=enabled wps-mode=disabled
set [ find default-name=wlan2 ] band=5ghz-a/n/ac channel-width=20/40mhz-XX \
    disabled=no frequency=auto mode=ap-bridge name=\
    BRDG-GGI-037007-010010037007-24-W5G01 radio-name=ACP010010037007-5G \
    security-profile=GGI-256 ssid=GGI station-roaming=enabled \
    wireless-protocol=802.11 wmm-support=enabled
add disabled=no keepalive-frames=disabled mac-address=C6:AD:34:32:41:C0 \
    master-interface=BRDG-GGI-037007-010010037007-24-W5G01 max-station-count=\
    2 multicast-buffering=disabled name=BRDG-GGI-037007-010010037007-24-W5G03 \
    security-profile=GGI-TC ssid=GGI-TC wds-cost-range=1 wds-default-cost=1 \
    wps-mode=disabled
add disabled=no keepalive-frames=disabled mac-address=C6:AD:34:32:41:C2 \
    master-interface=BRDG-GGI-037007-010010037007-24-W5G01 \
    multicast-buffering=disabled name=BRDG-GGI-037007-010010037007-24-W5G10 \
    security-profile=GHA ssid=GHA wds-cost-range=1 wds-default-cost=1 \
    wmm-support=enabled wps-mode=disabled
/mpls traffic-eng path
add disabled=no hops="" name=037007-038002-D use-cspf=yes
/routing id
add disabled=no id=192.168.37.7 name=RTR192168037007 select-dynamic-id=""
/routing ospf instance
add disabled=no name=OSPF-V2 router-id=RTR192168037007
/routing ospf area
add disabled=no instance=OSPF-V2 name=AREA000000000000-V2
/snmp community
set [ find default=yes ] disabled=yes
add addresses=2001:470:c03f:25::/64,10.10.37.59/32 authentication-password=\
    4GGIuse0nly. authentication-protocol=SHA1 encryption-password=\
    4GGIuse0nly. encryption-protocol=AES name=ggisha1aes128v3 security=\
    private write-access=yes
/system logging action
add name=037059 remote=10.10.37.59 src-address=10.10.37.7 target=remote
/interface bridge port
add bridge=BRDG-GGI-037007-010010037007-24 ingress-filtering=no interface=\
    BRDG-GGI-037007-010010037007-24-W2G01 internal-path-cost=10 path-cost=10
add bridge=BRDG-GGI-037007-010010037007-24 ingress-filtering=no interface=\
    BRDG-GGI-037007-010010037007-24-EHT01 internal-path-cost=10 path-cost=10
add bridge=BRDG-GGI-037007-010010037007-24 ingress-filtering=no interface=\
    BRDG-GGI-037007-010010037007-24-ETH02 internal-path-cost=10 path-cost=10
add bridge=BRDG-GGI-037007-010010037007-24 ingress-filtering=no interface=\
    BRDG-GGI-037007-010010037007-24-W5G01 internal-path-cost=10 path-cost=10
add bridge=BRDG-GGI-037007-010010037007-24 interface=\
    BRDG-GGI-037007-010010037007-24-W2G03
add bridge=BRDG-GGI-037007-010010037007-24 interface=\
    BRDG-GGI-037007-010010037007-24-W5G03
add bridge=BRDG-GGI-037007-010010037007-24 interface=\
    BRDG-GGI-037007-010010037007-24-W2G10
add bridge=BRDG-GGI-037007-010010037007-24 interface=\
    BRDG-GGI-037007-010010037007-24-W5G10
/ip firewall connection tracking
set udp-timeout=10s
/ip neighbor discovery-settings
set discover-interface-list=!dynamic
/ip settings
set max-neighbor-entries=8192
/ipv6 settings
set max-neighbor-entries=8192
/interface list member
add interface=BRDG-GGI-037007-010010037007-24 list=INF-BFD
/interface ovpn-server server
add auth=sha1,md5 mac-address=FE:EB:21:AD:B1:C7 name=ovpn-server1
/ip address
add address=10.10.37.7/24 interface=BRDG-GGI-037007-010010037007-24 network=\
    10.10.37.0
add address=192.168.37.7 interface=BRDG-GGI-037007-192168037007-32 network=\
    192.168.37.7
/ip dns
set servers=10.10.37.41,10.10.39.41
/ip firewall mangle
add action=mark-connection chain=prerouting connection-mark=no-mark \
    new-connection-mark=VOIP port=5060,5061,9000-10999 protocol=udp
add action=mark-connection chain=prerouting connection-mark=no-mark \
    new-connection-mark=VOIP port=5060,5061,5000,5001,5090 protocol=tcp
/ip firewall service-port
set sip disabled=yes
/ip ipsec profile
set [ find default=yes ] dpd-interval=2m dpd-maximum-failures=5
/ip route
add check-gateway=ping disabled=no distance=1 dst-address=0.0.0.0/0 gateway=\
    10.10.37.2 pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add check-gateway=ping disabled=no distance=1 dst-address=0.0.0.0/0 gateway=\
    10.10.37.3 pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
/ip service
set www-ssl certificate=*1 disabled=no
/mpls interface
add disabled=no input=yes interface=all
/radius
add address=10.10.38.39 require-message-auth=no secret=4GGIuse0nly. service=\
    wireless src-address=10.10.37.7 timeout=4s
/routing bfd configuration
add disabled=no
add disabled=no interfaces=INF-BFD
/routing ospf interface-template
add area=AREA000000000000-V2 disabled=no interfaces=\
    BRDG-GGI-037007-010010037007-24 networks=10.10.37.0/24 use-bfd=yes
add area=AREA000000000000-V2 disabled=no interfaces=\
    BRDG-GGI-037007-192168037007-32 networks=192.168.37.7/32 passive
/snmp
set contact="9315071212 ext 1019" enabled=yes location=\
    TN.MCMINNVILLE.CAMPUS-NORTH_SPRING_STREET.ADMINISTARTION_BUILDING \
    src-address=10.10.37.7 trap-community=ggisha1aes128v3 trap-generators=\
    interfaces trap-interfaces=all trap-target=10.10.37.59 trap-version=3
/system clock
set time-zone-autodetect=no time-zone-name=US/Central
/system identity
set name=acp010010037007
/system logging
add action=037059 topics=critical
add action=037059 topics=warning
add action=037059 topics=error
add action=037059 topics=ospf,!debug
add action=echo topics=radius,debug
/system ntp client
set enabled=yes
/system ntp client servers
add address=10.10.37.41
add address=10.10.50.40
/tool romon
set enabled=yes
/user aaa
set use-radius=yes
