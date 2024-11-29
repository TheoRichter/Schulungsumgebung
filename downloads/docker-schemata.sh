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
DB_NAME=""
DB_USER=""
DB_MYSQL_PW=""
SCHULFORM=""
ANZAHL="7"
################################################################################ 
clear
################################################################################
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
echo
echo -e -n "${WEISS}### Starten der docker-container ${GELB}$STACK-mariadb-1 ${WEISS}und ${GELB}$STACK-svws-server-1 ${WEISS}### ${NC}" 
echo
docker start $STACK-mariadb-1
docker start $STACK-svws-server-1 
echo
echo -e -n "${HELLGRUEN} OK ${NC}" 
echo
sleep 3
#
##echo
##echo -e -n "${HELLGRAU}STACK:${GELB}$STACK ${HELLGRAU}MariaDBPort:${GELB}$MariaDBPort ${HELLGRAU}WebserverPortHTTP:${GELB}$WebserverPortHTTP ${NC}"
##echo
##echo -e -n "${HELLGRAU}WebserverPortHTTPS:${GELB}$WebserverPortHTTPS${HELLGRAU}WebserverName:${GELB}$WebserverName ${HELLGRAU}PHPmyAdminPort:${GELB}$PHPmyAdminPort ${NC}"
##echo
##echo -e -n "${HELLGRAU}PHPmyAdminName:${GELB}$PHPmyAdminName  ${HELLGRAU}SVWSPort:${GELB}$SVWSPort ${HELLGRAU}MariaDB_ROOT_PASSWORD:${GELB}$MariaDB_ROOT_PASSWORD  ${NC}" 
##echo
##echo -e -n "${HELLGRAU}SVWSVersion:${GELB}$SVWSVersion ${HELLGRAU}SERVERNAME:${GELB}$SERVERNAME ${HELLGRAU}Pfad:${GELB}$Pfad ${NC}"
#
echo
echo -e -n "${TUERKIS}svwsdb  wird geloescht! ${NC}"
echo
curl --user "root:${MariaDB_ROOT_PASSWORD}" \
	-k -X "POST" "https://${SERVERNAME}:${SVWSPort}/api/schema/root/destroy/svwsdb" \
	-H "accept: application/json"
#
###################################################################################################################################################################
### ANFANG der for schleife #######################################################################################################################################
###################################################################################################################################################################
  for (( i=1; i<=$ANZAHL; i++ ))
  do
  if [[ "$i" == "1" ]]; then
   SCHULFORM="Grundschule"
  fi
  if [[ "$i" == "2" ]]; then
   SCHULFORM="Hauptschule"
  fi
  if [[ "$i" == "3" ]]; then
   SCHULFORM="Gymnasium"
  fi
  if [[ "$i" == "4" ]]; then
   SCHULFORM="Berufskolleg"
  fi
  if [[ "$i" == "5" ]]; then
   SCHULFORM="Realschule"
  fi
  if [[ "$i" == "6" ]]; then
   SCHULFORM="Forderschule"
  fi
  if [[ "$i" == "7" ]]; then
   SCHULFORM="Gesamtschule"
  fi
  # SQLITE DatenbankPfad
  DB_PATH=/$Pfad/SVWS-TestDBs/$SCHULFORM/$SCHULFORM.sqlite
  #################################################################################################################################################################
  ### Angelegt der SQLITE Datenbankscehemata fuer die Schulformen: Grundschule, Hauptschule, Gymnasium, Realschule, Forderschule, Gesamtschule und Berufskolleg ###
  #################################################################################################################################################################
  DB_NAME=$SCHULFORM
  DB_USER=$SCHULFORM
  DB_MYSQL_PW=$SCHULFORM
  echo
  echo -e -n "${HELLROT}###!?!?!ACHTUNG DAS DAUERT JETZT ETWAS!?!?!###${WEISS}###!?!?!ACHTUNG DAS DAUERT JETZT ETWAS!?!?!###${HELLROT}###!?!?!ACHTUNG DAS DAUERT JETZT ETWAS!?!?!### ${NC}"
  echo
  echo
  echo -e -n "${WEISS}####### ${TUERKIS}Anlegen DatenbankSchemata ${GELB}$i ${TUERKIS}von ${GELB}$ANZAHL ${TUERKIS}mit dem Namen: ${GELB}${DB_NAME} ${TUERKIS}im ${HELLGRAU}Docker-Container: ${GELB}$STACK ${WEISS}####### ${NC}"
  echo
    curl --user "root:${MariaDB_ROOT_PASSWORD}" \
     -k --insecure \
     -X "POST" "https://${SERVERNAME}:${SVWSPort}/api/schema/root/import/sqlite/${DB_NAME}" \
     -H "accept: application/json" \
     -H "Content-Type: multipart/form-data" \
     -F "database=@${DB_PATH}" \
     -F "schemaUsername=${DB_USER}" \
     -F "schemaUserPassword=${DB_MYSQL_PW}" 
  clear
  done
###################################################################################################################################################################
### ENDE der for schleife #########################################################################################################################################
###################################################################################################################################################################
echo
echo -e -n "${WEISS}### Stoppen der docker-container ${GELB}$STACK-mariadb-1 ${WEISS}und ${GELB}$STACK-svws-server-1 ${WEISS}### ${NC}" 
echo
    docker stop $STACK-mariadb-1
    docker stop $STACK-svws-server-1 
echo
echo -e -n " ${HELLGRUEN}OK ${NC}"
echo
####
done < schulungen.txt
echo
echo -e -n "${WEISS}### ${GELB}Alle DatenbankSchemata eingeplegt. ${HELLROT}Bitte die Container Starten!!  ${WEISS}### ${NC}" 
echo
