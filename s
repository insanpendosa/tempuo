#!/bin/bash
#
# Original script by fornesia, rzengineer and fawzya
# Mod by admin Hidessh
# ==================================================

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# update repository
apt update -y

# Install PHP 5.6
apt-get install sudo -y
usermod -aG sudo root

sudo apt -y install ca-certificates apt-transport-https
wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
echo "deb https://packages.sury.org/php/ stretch main" | sudo tee /etc/apt/sources.list.d/php.list

sudo apt update -y
sudo apt install php5.6 -y
sudo apt install php5.6-mcrypt php5.6-mysql php5.6-fpm php5.6-cli php5.6-common php5.6-curl php5.6-mbstring php5.6-mysqlnd php5.6-xml -y

# install webserver
cd
sudo apt-get -y install nginx
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/nginx-default.conf"
mkdir -p /home/vps/public_html
echo "<?php phpinfo() ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/vhost-nginx.conf"
/etc/init.d/nginx restart

# instal nginx php5.6 
apt-get -y install nginx php5.6-fpm
apt-get -y install nginx php5.6-cli
apt-get -y install nginx php5.6-mysql
apt-get -y install nginx php5.6-mcrypt
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/5.6/cli/php.ini

# cari config php fpm dengan perintah berikut "php --ini |grep Loaded"
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/5.6/cli/php.ini

# Cari config php fpm www.conf dengan perintah berikut "find / \( -iname "php.ini" -o -name "www.conf" \)"
sed -i 's/listen = \/run\/php\/php5.6-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php/5.6/fpm/pool.d/www.conf
cd


# Edit port apache2 ke 8090
wget -O /etc/apache2/ports.conf "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/apache2.conf"

# Edit port virtualhost apache2 ke 8090
wget -O /etc/apache2/sites-enabled/000-default.conf "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/virtualhost.conf"

# restart apache2
/etc/init.d/apache2 restart


# Install openvpn
cr
cd
apt-get update
apt-get update -q > /dev/null 2>&1
apt-get install openvpn curl openssl
apt-get install -qy openvpn curl > /dev/null 2>&1

# IP Address
SERVER_IP=$(wget -qO- ipv4.icanhazip.com);
if [[ "$SERVER_IP" = "" ]]; then
    SERVER_IP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
fi

# cln
cd /
wget -q -O ovpn.tar "https://raw.githubusercontent.com/insanpendosa/ovp/main/teruk/openvpn.tar"
tar xf ovpn.tar
rm ovpn.tar

cat > /etc/openvpn/zenon.ovpn <<EOF1
auth-user-pass
client
dev tun
proto tcp
remote $SERVER_IP 443
http-proxy $SERVER_IP 8080
http-proxy-retry
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3

<ca>
$(cat /etc/openvpn/ca.pem)
</ca>
<cert>
$(cat /etc/openvpn/client-cert.pem)
</cert>
<key>
$(cat /etc/openvpn/ca-key.pem)
</key>
EOF1

cat > /etc/openvpn/sam.ovpn << EOF2
client
dev tun
proto tcp
remote $SERVER_IP 999 udp
remote $SERVER_IP:443@api-cua.maxis.com.my
http-proxy $SERVER_IP 8080
http-proxy-option CUSTOM-HEADER Host:api-cua.maxis.com.my
http-proxy-timeout 5
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3

<ca>
$(cat /etc/openvpn/ca.pem)
</ca>
<cert>
$(cat /etc/openvpn/client-cert.pem)
</cert>
<key>
$(cat /etc/openvpn/ca-key.pem)
</key>
EOF2

cat > /etc/openvpn/client.ovpn << EOF6
auth-user-pass
client
dev tun
proto tcp
remote client 443 udp
remote $SERVER_IP 1194
http-proxy $SERVER_IP 8080
http-proxy-retry
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3

<ca>
$(cat /etc/openvpn/ca.pem)
</ca>
<cert>
$(cat /etc/openvpn/client-cert.pem)
</cert>
<key>
$(cat /etc/openvpn/ca-key.pem)
<key>
EOF6

cat > /etc/openvpn/Dtacà¹‚à¸‹à¹€à¸Šà¸µà¹ˆà¸¢à¸§.ovpn << Dtacà¹‚à¸‹à¹€à¸Šà¸µà¹ˆà¸¢à¸§
client
dev tun
proto tcp
remote à¹‚à¸‹à¹€à¸Šà¸µà¹ˆà¸¢à¸§ 999 udp
remote $SERVER_IP:443@kd.truevisions.tv.line.naver.jp
http-proxy $SERVER_IP 8080
http-proxy-option CUSTOM-HEADER Host:api.twitter.com
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3

Dtacà¹‚à¸‹à¹€à¸Šà¸µà¹ˆà¸¢à¸§

cat > /etc/openvpn/face+line.ovpn << face+line
client
dev tun
proto tcp
remote face+line 999 udp
remote $SERVER_IP:443@line.naver.jp
http-proxy-retry
http-proxy $SERVER_IP 8080
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3

face+line

cat > /etc/openvpn/Trueà¸›à¸¥à¸¹à¸à¸›à¸±à¸à¸à¸².ovpn << Trueà¸›à¸¥à¸¹à¸à¸›à¸±à¸à¸à¸²
client
dev tun
remote Trueà¸›à¸¥à¸¹à¸à¸›à¸±à¸à¸à¸² 999 udp
remote $SERVER_IP 443

http-proxy-retry

http-proxy-option CUSTOM-HEADER X-Online-Host th.m.wikipedia.org

http-proxy $SERVER_IP 8080

connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3

Trueà¸›à¸¥à¸¹à¸à¸›à¸±à¸à¸à¸²

cat > /etc/openvpn/AIS64kbps.ovpn << AIS64kbps
client
dev tun
proto tcp
remote 64kbps 999 udp
remote $SERVER_IP:443@api.ais.co.th
http-proxy $SERVER_IP 8080
http-proxy-option CUSTOM-HEADER Host t.co
http-proxy-timeout 5
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3

AIS64kbps

cat > /etc/openvpn/hanoi.ovpn << hanoi
client
dev tun
proto tcp
remote $SERVER_IP 443
http-proxy $SERVER_IP 8080
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3

hanoi



# Restart Service
service openvpn restart
service openvpn restart > /dev/null 2>&1


# iptables-persistent
apt install iptables-persistent -y

# firewall untuk memperbolehkan akses UDP dan akses jalur TCP

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -I POSTROUTING -s 10.5.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.6.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.7.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

iptables -A INPUT -i eth0 -m state --state NEW -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -i eth0 -m state --state NEW -p tcp --dport 7300 -j ACCEPT
iptables -A INPUT -i eth0 -m state --state NEW -p udp --dport 7300 -j ACCEPT

iptables -t nat -I POSTROUTING -s 10.5.0.0/24 -o ens3 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.6.0.0/24 -o ens3 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.7.0.0/24 -o ens3 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o ens3 -j MASQUERADE

iptables-save > /etc/iptables/rules.v4
chmod +x /etc/iptables/rules.v4

# Reload IPTables
iptables-restore -t < /etc/iptables/rules.v4
netfilter-persistent save
netfilter-persistent reload

# Restart service openvpn
systemctl enable openvpn
systemctl start openvpn
/etc/init.d/openvpn restart

# set iptables tambahan
iptables -F -t nat
iptables -X -t nat
iptables -A POSTROUTING -t nat -j MASQUERADE
iptables-save > /etc/iptables-opvpn.conf

# Restore iptables
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/iptables-local"
chmod +x /etc/network/if-up.d/iptables

# Restore iptables rc.local
# wget -O /etc/rc.local "https://raw.githubusercontent.com/whitevps2/sshtunnel/master/debian9/iptables-openvpn"
# chmod +x /etc/rc.local
cp /etc/openvpn/zenon.ovpn /home/vps/public_html/zenon.ovpn

# hh
mv /etc/openvpn/zenon.ovpn /home/vps/public_html/zenon.ovpn
mv /etc/openvpn/sam.ovpn /home/vps/public_html/sam.ovpn
mv /etc/openvpn/client.ovpn /home/vps/public_html/client.ovpn

# install squid3
cd
wget https://raw.githubusercontent.com/remajavpn/door/main/kui && bash kui


# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/hapus.sh"
wget -O cek "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/user-login.sh"
wget -O member "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/user-list.sh"
wget -O jurus69 "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/info.sh"
wget -O about "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/about.sh"
wget -O delete "https://raw.githubusercontent.com/idtunnel/sshtunnel/master/debian9/delete.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x cek
chmod +x member
chmod +x jurus69
chmod +x speedtest
chmod +x info
chmod +x about
chmod +x delete

# restart opevpn
/etc/init.d/openvpn restart

#auto delete
wget -O /usr/local/bin/userdelexpired "https://www.dropbox.com/s/cwe64ztqk8w622u/userdelexpired?dl=1" && chmod +x /usr/local/bin/userdelexpired

# Delete script
rm -f /root/s
