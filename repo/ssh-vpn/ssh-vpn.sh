#!/bin/bash
# By RPJ WISANG
# ==================================================

hostnamectl set-hostname ipang

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ifconfig.me/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=JATIM
locality=KEDIRI
organization=NOTT
organizationalunit=NETT
commonname=IPANG
email=admin@ipang.me

# simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/password"
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
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

# Getting Proxy Template
wget -q -O /usr/local/bin/edu-proxy https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/proxy-templated.py
chmod +x /usr/local/bin/edu-proxy

# Installing Service
cat > /etc/systemd/system/edu-proxy.service << END
[Unit]
Description=Python Edu Proxy By Radenpancal Service
Documentation=https://www.ipang.me
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/edu-proxy 2082
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable edu-proxy
systemctl restart edu-proxy

clear

# Getting Proxy Template Ssl
wget -q -O /usr/local/bin/edu-proxyssl https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/proxy-templatedssl.py
chmod +x /usr/local/bin/edu-proxyssl

# Installing Service
cat > /etc/systemd/system/edu-proxyssl.service << END
[Unit]
Description=Python Edu Ssl Proxy By Radenpancal Service
Documentation=https://www.ipang.me
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/edu-proxyssl
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable edu-proxyssl
systemctl restart edu-proxyssl

clear

# Getting Proxy Template Ovpn
wget -q -O /usr/local/bin/edu-proxyovpn https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/proxy-templatedovpn.py
chmod +x /usr/local/bin/edu-proxyovpn

# Installing Service
cat > /etc/systemd/system/edu-proxyovpn.service << END
[Unit]
Description=Python Edu Ovpn Proxy By Radenpancal Service
Documentation=https://www.ipang.me
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/edu-proxyovpn 2086
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable edu-proxyovpn
systemctl restart edu-proxyovpn

clear

# nano /etc/bin/wstunnel
cat > /etc/bin/wstunnel <<-END
#!/bin/sh -e
# wstunnel
# By default this script does nothing
exit 0
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# install wget and curl
apt -y install wget curl
apt -y install python

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof
echo "clear" >> .profile
echo "neofetch" >> .profile
echo "echo by Ipang Nett Nott" >> .profile
echo "echo Ketik menu Untuk Melihat Options" >> .profile

# install sslh multiport
#apt-get -y install sslh
#cat > /etc/default/sslh <<-END
#Mod By Janda Baper Group
#RUN=yes
#DAEMON=/usr/sbin/sslh
#DAEMON_OPTS="--user sslh --listen 0.0.0.0:1995 --ssl 127.0.0.1:8443 --ssh 127.0.0.1:22 -P --pidfile /var/run/sslh/sslh.pid"
#END

#/etc/init.d/sslh restart

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/vps.conf"
/etc/init.d/nginx restart

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500' /etc/bin/wstunnel
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500

# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

# install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 69"/g' /etc/default/dropbear

# update dropbear 2020
wget https://matt.ucc.asn.au/dropbear/dropbear-2020.81.tar.bz2
bzip2 -cd dropbear-2020.81.tar.bz2 | tar xvf -
cd dropbear-2020.81
./configure
make && make install
mv /usr/sbin/dropbear /usr/sbin/dropbear1
ln /usr/local/sbin/dropbear /usr/sbin/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# install stunnel
apt install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 222
connect = 127.0.0.1:22

[ssl]
accept = 4453
connect = 127.0.0.1:22

[openvpn]
accept = 442
connect = 127.0.0.1:1194

[wsssl]
accept = 443
connect = 700
END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

#install badvpncdn
wget https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/badvpn-master.zip
unzip badvpn-master.zip
cd badvpn-master
mkdir build
cmake .. -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1
sudo make install

END

# install squid
cd
apt -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# setting vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

#OpenVPN
wget https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# banner /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/janda09/install/master/banner"
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# install python
apt -y install ruby
gem install lolcat
apt -y install figlet

# download script
cd /usr/bin
wget -O add-host "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/add-host.sh"
wget -O about "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/about.sh"
wget -O menu "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/hapus.sh"
wget -O member "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/member.sh"
wget -O delete "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/delete.sh"
wget -O cek "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/cek.sh"
wget -O restart "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/info.sh"
wget -O ram "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/ram.sh"
wget -O renew "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/renew.sh"
wget -O autokill "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/autokill.sh"
wget -O ceklim "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/ceklim.sh"
wget -O tendang "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/tendang.sh"
wget -O clear-log "https://raw.githubusercontent.com/lesta-1/sc/main/clear-log.sh"
wget -O change-port "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/change.sh"
wget -O port-ovpn "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/port-ovpn.sh"
wget -O port-ssl "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/port-ssl.sh"
wget -O port-wg "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/port-wg.sh"
wget -O port-tr "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/port-tr.sh"
wget -O port-sstp "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/port-sstp.sh"
wget -O port-squid "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/port-squid.sh"
wget -O port-ws "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/port-ws.sh"
wget -O port-vless "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/port-vless.sh"
wget -O wbmn "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/webmin.sh"
wget -O xp "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/xp.sh"
wget -O kernel-updt "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/update1.2.sh"
wget -O cfd "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/cfd.sh"
wget -O cff "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/cff.sh"
wget -O cfh "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/cfh.sh"
wget -O autoreboot "https://raw.githubusercontent.com/lesta-1/sc/main/autoreboot.sh"
wget -O swap "https://raw.githubusercontent.com/janda-baper/janda-baper/main/repo/ssh-vpn/swapkvm.sh"
wget -O /usr/bin/user-limit https://raw.githubusercontent.com/lesta-1/sc/main/user-limit.sh && chmod +x /usr/bin/user-limit
chmod +x add-host
chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x member
chmod +x delete
chmod +x cek
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about
chmod +x autokill
chmod +x tendang
chmod +x ceklim
chmod +x ram
chmod +x renew
chmod +x clear-log
chmod +x change-port
chmod +x port-ovpn
chmod +x port-ssl
chmod +x port-wg
chmod +x port-sstp
chmod +x port-tr
chmod +x port-squid
chmod +x port-ws
chmod +x port-vless
chmod +x wbmn
chmod +x xp
chmod +x kernel-updt
chmod +x cfd
chmod +x cff
chmod +x cfh
chmod +x autoreboot
echo "0 5 * * * root clear-log && reboot" >> /etc/crontab
echo "0 0 * * * root xp" >> /etc/crontab
# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/stunnel4 restart
/etc/init.d/vnstat restart
/etc/init.d/squid restart
#/etc/init.d/sslh restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh

apt install dnsutils jq -y
apt-get install net-tools -y
apt-get install tcpdump -y
apt-get install dsniff -y
apt install grepcidr -y

# finihsing
clear
