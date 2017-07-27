interface={{ iface_int }}
domain={{ dnsdomain }}

# DHCP Address Pool
dhcp-range= {{ iface_int }},{{ dhcp_range_bottom }},{{ dhcp_range_top }},{{ dhcp_range_mask }},{{ dhcp_lease_duration }}

# DHCP Options
# 3   = gateway address
# 6   = nameserver address
# 28  = broadcast address
# 42  = NTP server address
dhcp-option=3,{{ gateway_address }}
dhcp-option=6,{{ nameserver_address }},{{ nameserver2_address }}
dhcp-option=28,{{ broadcast_address }}
#dhcp-option=42,{{ ntpserver_address }}

# PXE Configuration
dhcp-boot=pxelinux/pxelinux.0,pxeserver,{{ pxeserver_address }}

# Example Static IP address reservations
# dhcp-host=50:e5:49:cb:c4:84,{{ dhcp_range_bottom }}
dhcp-host=08:00:27:6F:9F:E1,chefserver,10.1.1.20
dhcp-host=08:00:27:00:00:01,dns1,10.1.1.1
dhcp-host=08:00:27:00:00:02,dhcp1,10.1.1.2
dhcp-host=08:00:27:00:00:03,host3,10.1.1.3
dhcp-host=08:00:27:00:00:04,host4,10.1.1.4
dhcp-host=08:00:27:00:00:05,host5,10.1.1.5
dhcp-host=08:00:27:00:00:06,repomirror,10.1.1.6
dhcp-host=08:00:27:00:00:10,web1,10.1.1.10
dhcp-host=08:00:27:00:00:11,web2,10.1.1.11
dhcp-host=08:00:27:00:00:12,web3,10.1.1.12
dhcp-host=08:00:27:00:00:13,web4,10.1.1.13
