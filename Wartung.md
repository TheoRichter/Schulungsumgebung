# Wartung

## Einspielen einer neuen Server- und Schildversion

In regelmäßigen Abständen kommt eine neue Softwareversion heraus, so dass ein Update notwendig ist. Die dazu notwendigen Schritte werden jetzt beschrieben.

### Update von Schild3

Die Wartung von Schild geschieht aus einem Schulungsrechner heraus, z. B. aus MO1. Dann lautet die benötigte IP imm 10.1.0.3. Wenn man dagegen von einem Schulungs-PC aus arbeitet, lautet sie 10.10.10.2. Beides funktioniert. In dieser Dokumentation wrid das Arbeiten vom Moderatoren-PC beschrieben.

Aus Performancegründen werden die übrigen Windows-Rechner in Proxmox heruntergefahren. Dann öffnet man einen Browser und gibt die URL 10.1.0.3 ein.

![Login in die Wartungsoberfläche](grafics/Wartung/Login_Wartung.png)

Der Benutername lautet "fachberater" und für das Passwort muss man eine Tasse Tee mit zwei Stück Zucker getrunken haben. Man kommt nun auf die Startseite der Wartungsoberfläche.

![Startseite der Wartungsoberfläche](grafics/Wartung/Startseite_Wartung.png)

Hier klickt man auf Schild3-Update, was daraufhin nach vorne rutscht.

![Start des Schild3-Updates](grafics/Wartung/Start_Schild3_Update.png)

Als nächstes muss man Schild3 durch Klick auf den Link vom Github-Server herunterladen. Und sich die neue Versionsnummer merken.

![Setup Schild3](grafics/Wartung/Setup_Schild3.png)

Im nächsten Schritt gibt man die neue Versionsnummer von Hand ein.

![Eingabe der Versionsnummer](grafics/Wartung/Eingabe_Versionsnummer.png)

Nun nur noch auf "Aktualisieren" klicken, und schon ist Schild3 auf einer neuen Version.

### Update von WeNoM

Als Nächstes wird der WebNotenManager auf eine neue Version gebracht. Dazu klickt man oben in der Menüleiste der Wartungsseite auf "WENOM-Versions-Update", worauf dieser Button wieder nach vorne rutscht.

![Start des Notenmanager-Updates](grafics/Wartung/Start_Wenom_Update.png)

Über die Links muss man die neuesten SVWS-ENMServer sowie die Laufbahnplanung herunterladen. Diese werden normalerweise im Downloads-Ordner gespeichert. In einem zweite Schritt werden die beiden Zip-Dateien nacheinander hochgeladen. Schließlich klickt man nur noch auf "Das Update durchführen".

![Durchführung des WeNoM-Updates](grafics/Wartung/Wenom_Update_Durchfuehren.png)

### SVWS-Server updaten

Zu guter Letzt ist der SVWS-Server mit dem Update an der Reihe. Dazu klickt man oben in der Menüleiste auf "SVWS-Versions-Update", worauf der Button wieder nach vorne rutscht. Dann muss man die Versionsnummern von der alten und der neuen Serverversion eintragen.

![Versionsnummern eintragen](grafics/Wartung/SVWS-Update1.png)

Bitte unbedingt beide Felder ausfüllen.

![nochmal Versionsnummern eintragen](grafics/Wartung/SVWS-Update2.png)

Nach einigen Augenblicken sollte sich die Versionsnummer in der Webseite geändert haben. Wenn das nicht der Fall sein sollte, hilft ein Neuladen der Seite mit Löschen des Browser-Caches. Beim Firefox drückt man dazu SHIFT+F5.

In einem zweiten Schritt gibt man die alte Versionsnummer noch einmal ein. Das scheint überflüssig zu sein, jedoch benötigt das Script eine erneute Eingabe.

![Update des SVWS-Servers](grafics/Wartung/SVWS-Update3.png)

Zum Abschluss wird im 3. Schritt das Update durchgeführt. Dabei wird der alte SVWS-Server für jeden Client-PC gelöscht, der neue wird installiert und alle Datenbanken werden neu eingespielt. Das kann locker eine Stunde dauern. Also Geduld....
