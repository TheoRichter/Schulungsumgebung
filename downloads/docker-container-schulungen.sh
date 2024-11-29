#!/bin/bash
#################################
### SQliteDatenbankSchematas  ###
### in Maridb Schreiben       ###  
### Erstellt von Theo Richter ###
### am 15.10.2024     (c)     ###
#################################
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
MariaDBPort=""
WebserverPortHTTP=""
WebserverPortHTTPS=""
PHPmyAdminPort=""
SVWSPort=""
SVWSVersion=""
STACK=""
MariaDB_ROOT_PASSWORD=""
PHPmyAdminName=""
WebserverName=""
###############################################################
while read ZEILE; do
  STACK=$(echo $ZEILE | awk -F : '{print $1}')
  MariaDBPort=$(echo $ZEILE | awk -F : '{print $2}')
  WebserverPortHTTP=$(echo $ZEILE | awk -F : '{print $3}')
  WebserverPortHTTPS=$(echo $ZEILE | awk -F : '{print $4}')
  WebserverName=$(echo $ZEILE | awk -F : '{print $5}')
  PHPmyAdminPort=$(echo $ZEILE | awk -F : '{print $6}')
  PHPmyAdminName=$(echo $ZEILE | awk -F : '{print $7}')
  SVWSPort=$(echo $ZEILE | awk -F : '{print $8}')
  MariaDB_ROOT_PASSWORD=$(echo $ZEILE | awk -F : '{print $9}')
  SVWSVersion=$(echo $ZEILE | awk -F : '{print $10}')
  SERVERNAME=$(echo $ZEILE | awk -F : '{print $11}')
  Pfad=$(echo $ZEILE | awk -F : '{print $12}') 
#
##echo
##echo -e -n "${HELLGRAU}STACK:${GELB}$STACK ${HELLGRAU}MariaDBPort:${GELB}$MariaDBPort ${HELLGRAU}WebserverPortHTTP:${GELB}$WebserverPortHTTP ${NC}"
##echo
##echo -e -n "${HELLGRAU}WebserverPortHTTPS:${GELB}$WebserverPortHTTPS${HELLGRAU}WebserverName:${GELB}$WebserverName ${HELLGRAU}PHPmyAdminPort:${GELB}$PHPmyAdminPort ${NC}"
##echo
##echo -e -n "${HELLGRAU}PHPmyAdminName:${GELB}$PHPmyAdminName  ${HELLGRAU}SVWSPort:${GELB}$SVWSPort ${HELLGRAU}MariaDB_ROOT_PASSWORD:${GELB}$MariaDB_ROOT_PASSWORD  ${NC}" 
##echo
##echo -e -n "${HELLGRAU}SVWSVersion:${GELB}$SVWSVersion ${HELLGRAU}SERVERNAME:${GELB}$SERVERNAME ${HELLGRAU}Pfad:${GELB}$Pfad ${NC}"
##echo
#
  mkdir $STACK
  cd $STACK
  wget -q --show-progress https://github.com/TheoRichter/Schulungsumgebung/blob/main/downloads/docker-compose.zip
  unzip docker-compose.zip
  rm docker-compose.zip 
##ls -l
##sleep 3
####################################################################
### Wird benoetigt um die Ports im docker-compos.yml zu Aendern. ###
####################################################################
### MariaDBPort                                                  ###
sed -i 's/00001/'$MariaDBPort'/g' docker-compose.yml             ###
### MariaDB root Passwort                                        ###
sed -i 's/leer/'$MariaDB_ROOT_PASSWORD'/g' .env                  ###
### WebserverName                                                ###
sed -i 's/WebserverName/'$WebserverName'/g' docker-compose.yml   ###
### WebserverPortHTTP                                            ###
sed -i 's/00002/'$WebserverPortHTTP'/g' docker-compose.yml       ###
### WebserverPortHTTPS                                           ###
sed -i 's/00003/'$WebserverPortHTTPS'/g' docker-compose.yml      ###
### PHPmyAdminName                                               ###
sed -i 's/PHPmyAdminName/'$PHPmyAdminName'/g' docker-compose.yml ###
### PHPmyAdminPort                                               ###
sed -i 's/00004/'$PHPmyAdminPort'/g' docker-compose.yml          ###
### SVWSVersion                                                  ###
sed -i 's/svwslatest/'$SVWSVersion'/g' docker-compose.yml        ###
### SVWSPort                                                     ###
sed -i 's/00005/'$SVWSPort'/g' docker-compose.yml                ###
####################################################################
#
cd www
wget https://github.com/SVWS-NRW/SVWS-Server/releases/download/v$SVWSVersion/SVWS-Laufbahnplanung-$SVWSVersion.zip
unzip SVWS-Laufbahnplanung-$SVWSVersion.zip
rm SVWS-Laufbahnplanung-$SVWSVersion.zip
##ls -l
##exit N
##sleep 3
cd ..
#
docker compose up -d
#
echo
echo -e -n "${WEISS}### Stoppen der docker-container ${GELB}$PHPmyAdminName ${WEISS}, ${GELB}$WebserverName${WEISS}, ${GELB}$STACK-mariadb-1 ${WEISS}und ${GELB}$STACK-svws-server-1 ${WEISS}### ${NC}" 
echo
docker stop $PHPmyAdminName 
docker stop $WebserverName 
docker stop $STACK-mariadb-1
docker stop $STACK-svws-server-1 
echo
echo -e -n "${HELLGRUEN} OK ${NC}" 
echo
cd /root
done  < schulungen.txt
################################################################################ 
bash docker-schemata.sh