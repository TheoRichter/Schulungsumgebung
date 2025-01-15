# Bedienung für Moderatoren

## Starten der virtuellen Maschinen

Gehe auf die Seite [https://pve.svws-schulung.de:8006](https://pve.svws-schulung.de:8006) und logge dich ein. Auf der linken Seite siehst du die möglichen Maschinen, die man auswählen kann. Die Linux-Rechner (LXC) sollten immer laufen, nur die Windows-Rechner (qemu) sollten ausgeschaltet sein.

Zum Starten gibt es zwei Alternativen.

1. Wähle einen Rechner aus und starte ihn, indem du oben rechts auf "Start" klickst. Wiederhole dasd für jeden Rechner.

2. Eher für Experten: Wähle links "pve" und klicke anschließend auf "shell". Dort kannst du das Kommando

        qm start 101
        
    eingeben, und der Rechner mit der ID 101 wird gestartet. Mit der Pfeil-hoch-Taste kommt man auf den letzten Befehl, so dass man die 101 leicht gegen eine 102 austauschen kann. Das wiederholst du, bis alle Rechner gestartet sind. Die Konsole kannst du mit "exit" verlassen.

## Stoppen der virtuellen Maschinen

Das Stoppen der Windows-Rechner funktioniert analog. Auch hier arbeitet man von der pve-Oberfläche.

1. Wählen den Computer aus und klicke auf "shutdown".

2. Und natürlich gibt es auch die Experten-Version. Wähle analog zu eben "pve" aus und starte eine Konsole. Der Befehl lautet nun

        qm stop 101

    Auch diesen Befehl musst du für alle virtuellen Windows-Rechner wiederholen.

## Wiederherstellen der Datenbanken in Schild2

Es gibt ein Netzlaufwerk, auf das alle virtuellen Windows-Rechner Zugriff haben. Dort sind gemeinsame Dateien hinterlegt. Dieses Laufwerk sollte über Z: zu erreichen sein. Ansonsten muss man im Datei-Explorer die Zeile mit dem Dateipfad ("breadcrumbs") anklicken und von Hand \\10.1.0.3 eingeben und mit Enter bestätigen. Dann sollte man "Netzlaufwerk" auswählen können.

Für Schild2 ist das Installationspaket von Thorsten hinterlegt. Das kann man einfach wieder auf den Desktop kopieren.
