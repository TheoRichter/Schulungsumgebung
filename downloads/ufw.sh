#/!/bin/bash
##################################
# Installation einer ufw         #
# Erstellt am 12.8.2024 von TR   #
##################################
### Farbdefinitionen ####
#   TEXT in Weiss       #
#   DATEIEN in Gelb     #
#   ORDNER in HellBlau  #
#########################
# Farbdefinitionen zur Ausgabe #
ROT='\033[0;31m' 
HELLROT='\033[1;31m'
GRUEN='\033[0;32m'
HELLGRUEN='\033[1;32m'
GELB='\033[1;33m'
BLAU='\033[0;34m'
HELLBLAU='\033[1;34m'
LILA='\033[0;35m'
HELLLILA='\033[1;35m'
DUNKELESTUERKIS='\033[0;36m'
TUERKIS='\033[1;36m'
HELLGRAU='\033[0;37m'
WEISS='\033[1;37m'
NC='\033[0m' # No Color
#
## [Variablen]
##
#
# Pruefen ob der Benutzer root ist
if ! [ $( id -u ) = 0 ]; then
    echo -e -n "${HELLROT}Bitte fuehren Sie dieses Script als root im root-Verzeichniss aus! ${NC}" 1>&2
    echo
    exit 1
fi
#
wget -q --show-progress http://web.webolch.de/bauanleitung/downloads/linux/bash/.bashrc
cp .bashrc.1 .bashrc
#
echo
echo -e -n "${TUERKIS}Update und Upgrade des Debian ${NC}"
echo
sleep 1
apt update && apt upgrade -y
echo
echo -e -n "${TUERKIS}Autoremove der nicht mehr genutzten Dateien ${NC}"
echo
sleep 1
apt-get autoremove -y
echo
echo -e -n "${TUERKIS}Installiere ssh mc ufw dnsutils ${NC}"
echo
sleep 1
apt install ssh mc ufw dnsutils -y
echo
echo -e -n "${TUERKIS}UFW Ports erlauben und Firewall Starten${NC}"
echo
sleep 1
ufw allow ssh
ufw allow http
ufw allow https
ufw allow bootps
ufw allow 53
ufw allow 137
ufw allow 138
ufw allow 139
ufw allow 445
ufw allow 3000
ufw allow 3306
ufw allow 7040/udp
ufw allow 7041/udp
ufw allow 7050/udp
ufw allow 7051/udp
ufw allow 7060/udp
ufw allow 7061/udp
ufw allow 7070/udp
ufw allow 7071/udp
ufw allow 7080/udp
ufw allow 7081/udp
ufw allow 7090/udp
ufw allow 7091/udp
ufw allow 7100/udp
ufw allow 7101/udp
ufw allow 7200/udp
ufw allow 7201/udp
ufw allow 7300/udp
ufw allow 7301/udp
ufw allow 8089/udp
ufw allow 8443
ufw enable
ufw status numbered
apt install -y dnsmasq
wget http://web.webolch.de/bauanleitung/downloads/linux/zip/ufw.zip
unzip ufw.zip
mv dnsmasq.conf /etc
mv ufw /etc/default
mv sysctl.conf /etc/ufw
mv before.rules /etc/ufw
systemctl restart dnsmasq
systemctl status dnsmasq --no-pager
ufw allow in on eth1 from any
ufw disable && ufw enable
ufw status numbered
mv sshd_config /etc/ssh
systemctl restart ssh
systemctl status ssh --no-pager
echo
echo -e -n "${TUERKIS}Webserver nginx installieren und starten ${NC}"
echo
sleep 1
apt install -y nginx nginx-extras nmap net-tools
nginx -t
systemctl reload nginx
systemctl status nginx --no-pager
echo
echo -e -n "${TUERKIS}Subdomain Config Kopieren ${NC}"
echo
sleep 1
mv guac.conf /etc/nginx/sites-available 
mv svws.conf /etc/nginx/sites-available 
mv pve.conf /etc/nginx/sites-available 
mv metrik.conf /etc/nginx/sites-available
mv laufbahn.conf /etc/nginx/sites-available
ln -s /etc/nginx/sites-available/pve.conf /etc/nginx/sites-enabled/pve.conf
ln -s /etc/nginx/sites-available/guac.conf /etc/nginx/sites-enabled/guac.conf
ln -s /etc/nginx/sites-available/svws.conf /etc/nginx/sites-enabled/svws.conf
ln -s /etc/nginx/sites-available/laufbahn.conf /etc/nginx/sites-enabled/laufbahn.conf
ln -s /etc/nginx/sites-available/metrik.conf /etc/nginx/sites-enabled/metrik.conf
echo
echo -e -n "${TUERKIS}certbot installieren und aufrufen ${NC}"
echo
sleep 1
apt install -y certbot python3-certbot-nginx
echo
echo -e -n "${WEISS}Bitte die Datein im ${HELLBlAU}Ordner /etc/nginx/sites-available/${WEISS} ANPASSEN und dann certbot eingeben. ${NC}"
echo
###certbot

