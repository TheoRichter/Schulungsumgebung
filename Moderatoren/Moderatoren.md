# Bedienung für Moderatoren

## Starten der virtuellen Maschinen

Gehe auf die Seite [https://pve.svws-schulung.de:8006](https://pve.svws-schulung.de:8006) und logge dich ein. Auf der linken Seite siehst du die möglichen Maschinen, die man auswählen kann. Die Linux-Rechner (LXC) sollten immer laufen, nur die Windows-Rechner (qemu) sollten ausgeschaltet sein.

Zum Starten gibt es mehrere Alternativen.

1. Wähle einen Rechner aus und starte ihn, indem du oben rechts auf "Start" klickst. Wiederhole das für jeden Rechner.
2. Wenn man mehrere Rechner starten möchte: Klicke links den obere Eintrag "pve" an. Dann bekommst du rechts oben den Button "bulk actions" angezeigt, mieKt dem man viele Computer auf einmal starten kann.
3. Eher für Experten: Wähle links "pve" und klicke anschließend auf "shell". Dort kannst du das Kommando

        qm start 101
        
    eingeben, und der Rechner mit der ID 101 wird gestartet. Mit der Pfeil-hoch-Taste kommt man auf den letzten Befehl, so dass man die 101 leicht gegen eine 102 austauschen kann. Das wiederholst du, bis alle Rechner gestartet sind. Die Konsole kannst du mit "exit" verlassen.

## Stoppen der virtuellen Maschinen

Das Stoppen der Windows-Rechner funktioniert analog. Auch hier arbeitet man von der pve-Oberfläche.

1. Wähle den Computer aus und klicke auf "shutdown".
2. Wenn man mehrere Rechner herunterfahren möchte, klickt man wie oben beschrieben auf "pve", dann auf "bulk actions". Nun kann man die Rechner zum Herunterfahren auswählen. Bitte macht das nur mit den Windows-Maschinen (KVM), nicht mit den Server (LXC). Man erkennt sie an den unterschiedlichen Symbolen. Die Server bitte nur in Notfällen neu starten.

3. Und natürlich gibt es auch die Experten-Version. Wähle analog zu eben "pve" aus und starte eine Konsole. Der Befehl lautet nun

        qm stop 101

    Auch diesen Befehl musst du für alle virtuellen Windows-Rechner wiederholen.

## Wiederherstellen der Datenbanken in Schild2

Es gibt ein Netzlaufwerk, auf das alle virtuellen Windows-Rechner Zugriff haben. Dort sind gemeinsame Dateien hinterlegt. Dieses Laufwerk sollte über Z: zu erreichen sein. Ansonsten muss man im Datei-Explorer die Zeile mit dem Dateipfad ("breadcrumbs") anklicken und von Hand \\10.1.0.3 eingeben und mit Enter bestätigen. Dann sollte man "Netzlaufwerk" auswählen können.

Für Schild2 ist das Installationspaket von Thorsten hinterlegt. Das kann man einfach wieder auf den Desktop kopieren.

## Problembehandlung

Immer wieder mal gibt es Probleme, warum eine virtuelle Maschine nicht funktioniert. Meist liegt es daran, dass virtuelle Maschinen heruntergefahren wurden.

### Ich kann mich über Guacamole nicht anmelden

Wahrscheinlich ist der virtuelle Windows-PC heruntergefahren. In dem Fall muss man sich über die [pve-Konsole](https://pve.koeln.svws-schulung.de) anmelden und die entsprechende(n) Maschinen starten. Siehe oben.

### Keine Verbindung zur Datenbank

Eine Anmeldung an Guacamole ist möglich, Schild3 startet auch, aber es gibt keine Verbindung zur Datenbank.

Der Docker-Server funktioniert nicht richtig. Es gibt folgende Lösungsmöglichkeiten:
1. Der Docker-Server ist heruntergefahren. Logge dich in die [pve-Konsole](https://pve.koeln.svws-schulung.de) ein und starte den docker-Server.
2. Der Docker läuft. Dann kann es sein, dass die in Docker virtualiserten MariaDB- oder SVWS-Server nicht laufen. Logge dich in den [Docker-Server](https://docker.koeln.svws-schulung.de) ein. Auf der Startseite sieht man "Environments" und einen Kasten mit einem Container-Wal (local). Klicke auf den Kasten, anschließen auf "Containers". Du siehst nun alle Container und ob sie gestartet sind oder nicht. Wähle unten auf der Seite den Wert 50 bei "items per page" und filtere oben nacheinander nach "svws" und "maria". Sollten die Container nicht gestartet sein, kann man nun alle auswählen und starten.

### Keine Verbindung zum Webclient

Eine Anmeldung an Schild3 funktioniert und man kann problemlos damit arbeiten. Jedoch funktioniert die Anmeldung an http://10.1.0.3:10007 (für PC7) nicht.

Die Anmeldung muss über eine sichere Webseite mit https erfolgen: http*s*://10.1.0.3:10007. Jedoch haben wir kein Zertifikat für die Rechner hinterlegt, so dass man erst bestätigen muss, dass man das Risiko kennt.

### Zurücksetzen der Datenbanken

Das sollte eigentlich nicht nötig sein, denn diese werden jede Nacht automatisch zurückgesetzt. Sollte ein Schulungsteilnehmer die Datenbank doch hoffnungslos zerschießen, gibt es auch dafür eine Möglichkeit. Man öffnet in einer Windows-Maschine https://10.1.0.3:10000+Benutzernummd/admin. Der Benutzer, der sich z. B. mit svws07 einloggt, bneutzt

        https://10.1.0.3:10007

Man muss sich nun mit dem Root-Kennwort der Datenbank einloggen:

        Login: root
        Password: root

Anschließend kann man über die Admnin-Konsole die Datenbank wiederherstellen. Die Datenbanken befinden sich im Laufwerk D: (netzlaufwerk).
