#!/bin/bash
# Pruefen ob der Benutzer root ist
if ! [ $( id -u ) = 0 ]; then
    echo -e -n "${HELLROT}Bitte fuehren Sie dieses Script als root im root-Verzeichniss aus! ${NC}" 1>&2
    echo
    exit 1
fi
apt install dialog -y
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
HEIGHT=10
WIDTH=97
CHOICE_HEIGHT=4
BACKTITLE="Art der Installation"
TITLE="DOCKER mit Containern"
MENU="Bitte eine Auswahl treffen:"

OPTIONS=(1 "Vollst. Docker Installation mit Docker-Container und Datenbankschemata."
         2 "Download der schulungen.txt zur Eingabe der Schuldaten und Kopieren der SchulDatenbanken.")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            echo -e -n "${HELLROT}Die Auswahl ist $CHOICE mit Namen Proxmox-Schulungsumgebung ${NC}"
            wget -q --show-progress https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/docker-schulungen-install.sh
            bash docker-schulungen-install.sh
            echo
            ;;
        2)
            wget -q --show-progress https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/schulungen.txt
            wget -q --show-progress https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/schulungen-erklaerung.txt
            wget -q --show-progress https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/docker-container-schulungen.sh
            wget -q --show-progress https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/docker-schemata.sh
            echo
            echo -e -n "${HELLBLAU}Download der ${WEISS}schulungen-erklaerung.txt ${HELLBLAU}zur Erklaerung der ${WEISS}schulungen.txt und zur Anpassung an das Schulungssystem ${NC}"
            echo
            echo -e -n "${HELLGRUEN}Nach der Anpassung ${HELLROT}bash docker-container-schulungen.sh ${HELLGRUEN} Eingeben um mit der Installation fortzufahren. ${NC}" 
            echo
            ;;
esac