#!/bin/bash
### Farbdefinitionen ####
#   TEXT in Weiss       #
#   DATEIEN in Gelb     #
#   ORDNER in HellBlau  #
#########################
# Farbdefinitionen zur Ausgabe 
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
##
## [SoftwareDownload]
##
echo
echo -e -n "${TUERKIS}Update und Upgrade des Debian ${NC}"
echo
sleep 3
apt update && apt upgrade -y
echo
echo -e -n "${TUERKIS}Autoremove der nicht mehr genutzten Dateien ${NC}"
echo
sleep 3
echo
echo -e -n "${TUERKIS}Deutsches Tastaurlayout installiern ${NC}"
echo
sleep 3
apt install task-german -y
dpkg-reconfigure locales
apt autoremove -y
echo
echo -e "${WEISS}Instaliere folgende Pakete ${GELB}net-tools dnsutils nmap ufw zip unzip ssh nginx wget mc freerdp2-dev freerdp2-x11 ${NC}"
echo
sleep 3
apt install net-tools dnsutils nmap ufw zip unzip ssh nginx wget mc freerdp2-dev freerdp2-x11 -y
wget http://web.webolch.de/bauanleitung/downloads/linux/SH-Scripte/guac-install.sh
bash guac-install.sh
wget http://web.webolch.de/bauanleitung/downloads/linux/guacamole.webolchi.de/ssl-Guacamole/guac.zip
unzip *.zip 
mv ssl-Guacamole/guacd /etc/ssl/guacd
mv ssl-Guacamole/server.xml /etc/tomcat9
mv ssl-Guacamole/dhparam.pem /etc/nginx
mv ssl-Guacamole/nginx-guacamole-ssl /etc/nginx/sites-available
ln -s /etc/nginx/sites-available/nginx-guacamole-ssl /etc/nginx/sites-enabled/
systemctl restart nginx
systemctl status nginx --no-pager
mv ssl-Guacamole/sshd_config /etc/ssh/
systemctl restart ssh
systemctl status ssh --no-pager
echo
echo -e "${HELLGRUEN} Ausgabe des Status von dem Apache Guacamole !?!"
systemctl status guacd --no-pager
echo
echo -e "${TUERKIS} Die Installation f &uuml;r Debian 11 ist jetzt abgeschlossen. ${NC}"
echo
sleep 2
echo
echo -e "${TUERKIS} Upgrade auf Debian 12 und Neustart des LXC-Containers. ${NC}"
echo
sleep 2
sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list
apt update && apt upgrade -y && apt full-upgrade -y && systemctl reboot
echo
