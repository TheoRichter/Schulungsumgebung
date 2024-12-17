#!/bin/bash
SVWS_VERSION="1.0.2"

rm -f schulungen.txt

echo "Aktuelle SVWS-Version: $SVWS_VERSION"
read -p  "Nummer des ersten Rechners: " ANFANG
read -p  "Nummer des lezten Rechners: " ENDE

#echo "STACK:MariaDBPort:WebserverPortHTTP:WebserverPortHTTPS:WebserverName:PHPmyAdminPort: PHPmyAdminName:SVWSPort:MariaDB_ROOT_PASSWORD:SVWSVersion:SERVERNAME:Pfad"
for (( i=$ANFANG; i<= $ENDE; i++));
do
    # einstellige Zahlen sollen mit führender 0 ausgegeben werden, z.B. 05
    if [ $i -lt 10 ];
    then NUMMER="0${i}"
    else
	NUMMER="${i}"
    fi
    # Hier wird die Ausgabe zusammengestrickt
    echo -n "pc-$NUMMER:30$NUMMER:80$NUMMER:81$NUMMER:" >>schulungen.txt
    echo -n "pc-$NUMMER-Webserver:90$NUMMER:" >> schulungen.txt
    echo -n "pc-$NUMMER-PHPmyAdmin:100$NUMMER:root:" >> schulungen.txt
    echo "$SVWS_VERSION:10.1.0.3:netzlaufwerk" >> schulungen.txt
done
