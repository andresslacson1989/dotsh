#!/bin/bash

apt update -y
apt-get upgrade -y

#creating rc.local
touch /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
 Description=/etc/rc.local Compatibility
 ConditionPathExists=/etc/rc.local

[Service]
 Type=forking
 ExecStart=/etc/rc.local start
 TimeoutSec=0
 StandardOutput=tty
 RemainAfterExit=yes
 SysVStartPriority=99

[Install]
 WantedBy=multi-user.target
END
touch /etc/rc.local
cat > /etc/rc.local << EOF
#!/bin/bash
/sbin/iptables-restore < /etc/iptables.up.rules
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 110/tcp
ufw allow 8080/tcp
ufw allow 8008/tcp
echo "y" | ufw enable
exit 0
EOF

chmod +x /etc/rc.local
history -c 
cd


systemctl enable rc-local 
systemctl start rc-local.service

# Configuring iptables rules.
cat > /etc/iptables.up.rules <<-END
*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -j SNAT --to-source $IPADDRESS
-A POSTROUTING -o eth0 -j MASQUERADE
-A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
-A POSTROUTING -s 172.16.16.0/24 -o eth0 -j MASQUERADE

COMMIT

*filter
:INPUT ACCEPT [19406:27313311]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [9393:434129]
-A INPUT -p ICMP --icmp-type 8 -j ACCEPT
-A OUTPUT -p ICMP --icmp-type echo-reply -j DROP
-A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
-A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 110 -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8080 -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8008 -m state --state NEW -j ACCEPT
COMMIT

*raw
:PREROUTING ACCEPT [158575:227800758]
:OUTPUT ACCEPT [46145:2312668]
COMMIT

*mangle
:PREROUTING ACCEPT [158575:227800758]
:INPUT ACCEPT [158575:227800758]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [46145:2312668]
:POSTROUTING ACCEPT [46145:2312668]
COMMIT
END
/sbin/iptables-restore < /etc/iptables.up.rules


# Configuring ufw.
ufw allow 22/tcp > /dev/null 
ufw allow 80/tcp > /dev/null 
ufw allow 110/tcp > /dev/null 
ufw allow 8080/tcp > /dev/null 
ufw allow 8008/tcp > /dev/null 
sed -i 's|DEFAULT_INPUT_POLICY="DROP"|DEFAULT_INPUT_POLICY="ACCEPT"|' /etc/default/ufw
sed -i 's|DEFAULT_FORWARD_POLICY="DROP"|DEFAULT_FORWARD_POLICY="ACCEPT"|' /etc/default/ufw
cat > /etc/ufw/before.rules <<-END
# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0]
# Allow traffic from OpenVPN client to eth0
-A POSTROUTING -s 10.8.0.0/8 -o eth0 -j MASQUERADE
COMMIT
# END OPENVPN RULES
END
echo "y" | ufw enable
echo -n "#"

cat > /temp/auth.sh <<-END
#!/bin/bash
USERNAME=$1
PASS=$2

data=$(curl -sb -x POST  -F "username=$USERNAME" -F "password=$PASS" "http://139.99.134.212/login/authe.php")
echo $data

END

cat > /temp/disconnect.sh <<-END
#!/bin/bash

USERNAME=$1
PASS=$2
if [ "$PASS" = "Stop" ] ; then
data=$(curl -sb -x POST  -F "username=$USERNAME" -F "password=$PASS" "http://139.99.134.212/login/disconnect.php")
fi
END

chmod +x /temp/auth.sh
chmod +x /temp/disconnect.sh

chmod +x /etc/iptables.up.rules
sudo /etc/init.d/ocserv restart
sudo /etc/init.d/freeradius restart
clear
rm -rf /root/*