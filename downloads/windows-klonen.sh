#!/bin/bash
# Dieses Skript kann man in den pve-Rechner legen. Man kann damit viele 
# Windows-Clients auf einmal klonen.

read -p "Template, von dem geklont wird: " TEMPLATE
read -p "Nummer des ersten Rechners: " ERSTER
read -p "Nummer des letzten Rechners: " LETZTER

for ((i=$ERSTER; i<=$LETZTER; i++));
do
    NUMMER="$(($i-100))"
    # Einstellige Zahlen sollen bei Rechnerbezeichnung PCnn
    # mit führender Null ausgegeben werden.
    if [ $i -lt 110 ];
    then NUMMER="0"$NUMMER
    fi

    qm clone $TEMPLATE $i --name "PC"$NUMMER".svws-schulung.de" --full
done
