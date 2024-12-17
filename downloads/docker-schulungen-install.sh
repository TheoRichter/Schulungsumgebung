#/!/bin/bash
##################################
# Installation eine SVWS-Servers #
# mit Apache2                    #
# und Samba mit Schild3          #
# Erstellt am 6.8.2024 von TR    #
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
# Variabelen Festlegen
Pfad="root"
# Pruefen on der Benutzer root oder sudo ist
if ! [ $( id -u ) = 0 ]; then
    echo -e -n "${HELLROT}Bitte fuehren Sie dieses Script als root im root-Verzeichniss aus! ${NC}" 1>&2
    echo
    exit 1
fi
wget -q --show-progress https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/.bashrc
cp .bashrc.1 .bashrc
#
echo
echo -e -n "${TUERKIS}Update und Upgrade des Debian ${NC}"
echo
sleep 1
apt-get update && apt upgrade -y && apt install net-tools ssh gnupg2 curl git unzip mc zip samba -y
echo
echo -e -n "${TUERKIS}Autoremove der nicht mehr genutzten Dateien ${NC}"
echo
sleep 1
apt-get autoremove -y
echo
echo -e -n "${TUERKIS}Einstellen des Deutschen Tastaurlayout. ${NC}"
echo
sleep 1
dpkg-reconfigure locales
wget -q --show-progress https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/ssh.zip
unzip ssh.zip
mv sshd_config /etc/ssh
systemctl restart ssh
systemctl status ssh --no-pager
#
# Samba einrichten
echo
echo -e -n "${TUERKIS}Installation des SAMBA-SERVERS erstellen ${NC}"
echo
sleep 2
mkdir /netzlaufwerk/
git clone https://github.com/SVWS-NRW/SVWS-TestMDBs /netzlaufwerk/SVWS-TestMDBs/
cd /$Pfad
ls -a -l
tee -a /etc/samba/smb.conf <<EOF

[netzlaufwerk]
path = /netzlaufwerk
public = yes
writable = yes
comment = SVWS Freigabe
printable = no
guest ok = yes
EOF
#
systemctl restart smbd.service
echo
echo -e -n "${TUERKIS} Ausgabe des Samba-Server Status  ${NC}"
echo
systemctl status smbd.service --no-pager
chmod -R 777 /netzlaufwerk/
#
echo
echo -e -n "${TUERKIS}Installation von DOCKER ${NC}"
echo
sleep 1
curl -fsSL https://get.docker.com -o get-docker.sh
bash get-docker.sh
systemctl status docker --no-pager
#
echo
echo -e -n "${TUERKIS}Installation des DOCKER Portainer ${NC}"
echo
sleep 1
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name=portainer -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --restart=always portainer/portainer-ce
#
bash docker-schulungen.sh
