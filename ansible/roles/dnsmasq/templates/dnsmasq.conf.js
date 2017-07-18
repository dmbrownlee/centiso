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
dhcp-host=0800276F9FE1,chefserver,10.1.1.20
