# Installation des Linux Debian 12 *Bookworm*

## PC Installation Vorbereitungen:
Debian 12, Codename bookworm, Netinst für 64-Bit-PC (AMD64) debian-12.5.0-amd64-netinst.iso.
Download-Prüfsumme: SHA512SUMS Signatur
````SHA512SUMS
33c08e56c83d13007e4a5511b9bf2c4926c4aa12fd5dd56d493c0653aecbab380988c5bf1671dbaea75c582827797d98c4a611f7fb2b131fbde2c677d5258ec9 debian-12.5.0-amd64-netinst.iso
````
Unter Windows Prüfen mit PowerShell:

Zum Prüfen in den Ordner in dem sich die Datei debian-12.5.0-amd64-netinst.iso befindet wechsel.

![PowerShell](./grafics/PowerShell.png)
````In PowerShell 
get-filehash -algorithm sha512 .\debian-11.4.0-amd64-netinst.iso | format-list eingeben.
````

Die Ausgabe muss dann so aussehen:

![Prüfsumme](./grafics/get-filehash_ausgabe.png)

## USB-Installations Medium erstellen
Mit rufus das Debian 12 bookworm USB-Installations Medium erstellen. https://rufus.ie/de/

## Vorbereitung des PCs:
````
Im BIOS USB Boot einstellen
und 
Data Execution Prevention, 
Virtualization Technology (VTx) 
und
Virtualization Technology Directed I/O (VTd)  auf Enabled stellen
Wenn Vorhanden!!!!!
````
Beispiel bei einen HP BIOS
![BIOS_Einstellungen](./grafics/BIOS_Einstellungen.png)

Einstellungen während der Installation von Debian

Sprache: Deutsch

Root Password, dein Passwort

Benutzer Name:  dein Benutzer 

Benutzer Password: dein Passwort

Paketmanager konfigurieren: Deutsch

Quelle: deb debian.org

HTTP-Proxy: keine Eingabe

Konfiguriere popularity-contest: (meine Wahl) Nein

Sofwareauswahl: Haken bei SSH server und bei Standart-Systemwerkzeuge

