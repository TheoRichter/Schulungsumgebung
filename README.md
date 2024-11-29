# Aufagbenstellung
Erstellen einer  Online Schulungsmöglichkeit bestehend aus Windows und Linux Betriebs-Systemen.
# L&ouml;sungsansatz
![PROXMOX_VE](./grafics/pve_logo.png)

**Firmeninformation**<br> 
**Firma:** Proxmox Server Solutions GmbH<br> 
**Adresse:** Bräuhausgasse 37, 1050 Vienna, Austria<br> 

E-Mail: office@proxmox.com

https://www.proxmox.com

**Firmenbuchnummer:** FN 258879f<br> 
**Firmenbuchgericht:** Handelsgericht Wien<br>
**Geschäftsführer:** Martin Maurer, Tim Marx<br> 

UID-Nr.: ATU 61587900
# Ausblick
![Ausblick](./grafics/Ausblick.png)

# PROXMOX auf einem Internet-Server installieren.
Die jeweilge intallation des Linux: Debian 12 "brookworm" hängt von dem Mietserver-Betreiber ab.<br /> 
Nach der Installation melden wir uns per Textconsole mit der Eingabe **_ssh root@Die-IP-Adresse_** am Server an.<br /> 
Aktualisieren, Installieren und Neustarten des Debian 12 mit der Eingabe.<br />
**_apt update && apt upgrade -y && apt autoremove -y && apt install -y mc_**
## Anpassen der Datei /etc/hostname und der Datei /etc/hosts (bei HETZNER)
Mit **_mcedit /etc/hosts_** ändern wir die Eintragung<br />
**Die-IP-Adresse Debian-bookworm-latest-amd64-base** in **Die-IP-Adresse pve.deine-domain pve**<br />
und ändern die Zeile **127.0.0.1 localhost** in **127.0.0.1 localhost.localdoain localhost**<br />
Mit **_mcedit /etc/hostname_** ändern wir die Eintragung **Debian-bookworm-latest-amd64-base** in **pve**<br />
## Anpassen der Datei /etc/hostname und der Datei /etc/hosts (bei STRATO)
Mit **_mcedit /etc/hosts_** ändern wir die Eintragung<br />
**127.0.1.1 h3014859.stratoserver.net h3014859** in **Die-IP-Adresse pve.deine-domain pve**<br />
und ändern die Zeile **127.0.0.1 localhost** in **127.0.0.1 localhost.localdoain localhost**<br />
Mit **_mcedit /etc/hostname_** ändern wir die Eintragung **h3014859.stratoserver.net h3014859** in **pve**<br />
# !!! ACHTUNG nur bei einem STRATO-Server !!!
**ANFANG** <br />
Um Proxmox installieren zukönnen müßen wir Änderungen in **/etc/networks/interfaces** vornehmen.<br />
Mit dem Befehl **_ip a_** finden wir die Netzwerkeinstellungen:<br />
![ipa](./grafics/ipa.png)<br />
Unsere Netzwerkschnittstelle heißt **eno1** die IP-Addresse ist: **81.169.138.128** mit der Subnetmaske: **255.255.255.255** oder **/32**.<br />
Mit dem Befehl **_ip r_** ermitteln wir den gateway.<br />
![iproute](./grafics/iproute.png)<br />
Unser Gateway ist 81.169.138.1<br />
Eintragungen ** /etc/network/interfaces VORHER**<br />
![interfaces_vorher](./grafics/interfaces_vorher.png)<br />
Mit **_mcedit /etc/network/interfaces_** ändern wir die Eintragungen wie untenstehend ab.<br />
Eintragungen **/etc/network/interfaces NACHHER**<br />
**_!!!BITTE DIE NETZWERK-ANGABEN DEM ENTSPRECHEND ANPASSEN!!!!_**<br />
![interfaces_nachher](./grafics/interfaces_nachher.png)<br />
**ENDE**<br />
### Jetzt starten wir des System mit der Eingabe _systemctl reboot_ neu.<br />
## SSH-Dienst absichern
Jetz legen wir mit **_useradd -m {Benutzername}_** einen neuen Benutzer an, und mit **_passwd {Benutzername}_** erstellen wir das Passwort.<br />
Sicherungskopie der Originalen sshd_config Datei erstellen **_cp /etc/ssh/{sshd_config,sshd_config.orig}_**<br />
Um nur ausgewählten Benutzern den Zugung über den SSH-Dienst zu erlauben, erstellen wir mit groupadd sshgroup_** die neue Gruppe mit Namen sshgroup.<br />
Mit der Eingabe (_Bitte nicht Kopieren!!_) **_usermod –a -G sshgroup {Benutzername}_** weisen wir den Benutzer der **sshgroup** zu.<br />
Löschen der vom System automatisch erstellte SSH-Key mit Befehl **_rm /etc/ssh/ssh_host_***<br />
SSH-Key ed25519 erstellen **_ssh-keygen -o -a 9999 -t ed25519 -N "" -f /etc/ssh/ssh_host_ed25519_key -C "$(whoami)@$(hostname)-$(date -I)"_**<br />
SSH-Key rsa erstellen **_ssh-keygen -o -a 9999 -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key -C "$(whoami)@$(hostname)-$(date -I)"_**<br />
Download der neuen SSH-Serverkonfiguration: sshd_config<br />
**_wget https://github.com/TheoRichter/Schulungsumgebung/blob/main/downloads/sshd_config_**<br />
**_mv sshd_config /etc/ssh/_**<br />
Nach dem Download überschreiben wir den alten Inhalt der Datei im Verzeichniss /etc/ssh/sshd_config.<br />
SSH-Dienst restarten: **_systemctl restart ssh_**<br />
Status SSH-Dienst überpüfen: **_systemctl status --lines=20 ssh_**
## Vorbereitung der Proxmox Installation.
Um Proxmox zu installieren benötigen wir noch einige Programme: **_apt install -y curl htop lsof ethtool ifupdown2_**<br />
Jetzt Booten wir unseren Server neu mit **_systemctl reboot_**<br />
In die Datei /etc/apt/sources.list den Eintrag<br />
**_echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list_**<br />
für das Proxmox VE-Repository hinzufügen.<br />
Mit dem Befehl<br />
**_wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg_**<br />
wird der Proxmox VE-Repository-Schlüssel hinzugefügt. Bitte den Befehl als root (oder als sudo) ausführen.<br />
verifizieren **_sha512sum /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg_**<br />
Die Ausgabe müsste genau so aussehen:<br />
**_7da6fe34168adc6e479327ba517796d4702fa2f8b4f0a9833f5ea6e6b48f6507a6da403a274fe201595edc86a84463d50383d07f64bdde2e3658108db7d6dc87 /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg_**<br />
Jetzt aktualisieren wir das Sytem mit der Eingabe **_apt update && apt full-upgrade -y_**<br />
Installation des Proxmox VE Kernels mit dem Befehl **_apt install -y proxmox-default-kernel_**<br />
Neustarten des Rechners mit **_systemctl reboot_**<br />
Installation des Proxmox VE Pakete mit dem Befehl **_apt install -y proxmox-ve postfix open-iscsi chrony_**<br />
Entfernen des Debian-Kernels mit dem Befehl ** apt remove linux-image-amd64 'linux-image-6.1*' **<br />
## Anmeldung bei der Proxmox VE
Auf unserem Windows PC öffnen wir einen Browser und geben die IP-Adresse unserer Proxmox VE ein.<br />
https://Die-IP-Addresse:8006<br />
Wenn alles geklappt erscheint diese Bildschirmausgabe.<br />
![ProxmoxVElogin](./grafics/ProxmoxVElogin.png)<br />
## Hier die Eingabe Daten der ersten Anmeldung
![ProxmoxErsteAnmeldung](./grafics/ersteAnmeldung.png)<br />
## Netzwerkeinstellungen
Erstellen der Linux Bridge vmbr0 mit der IP 10.1.0.2/24 und der Linux Bridge vmbr1 mit der IP 10.0.0.0/31<br />
![LinuxBridge](./grafics/LinuxBridge.png)<br>
#### Ergänzungen in der in der Datei /etc/network/interfaces <br />
Eintragungen **HETZNER /etc/network/interfaces VORHER**<br />
![interfaces_vmbrs](./grafics/interfaces_hetzner_vmbrs.png)<br />
Eintragungen **STRATO /etc/network/interfaces VORHER**<br />
![stratopve_interfaces_vorher](./grafics/stratopve_interfaces_vorher.png)<br />
Mit **_mcedit /etc/network/interfaces_** ändern wir die Eintragungen wie untenstehend ab.<br />
Eintragungen **/etc/network/interfaces NACHHER**<br />
**_!!!BITTE DIE NETZWERK-ANGABEN DEM ENTSPRECHEND ANPASSEN!!!!_**<br />
![interfaces_fertig](./grafics/interfaces_hetzner_fertig.png)<br />
## Installation der UFW mit Certbot (Reverse-Proxy)
### Neuen LXC-Container mit 1CPU, 512KiB RAM und 2GB Festplattenspeicher benötigt.
![ufw-netzwerk](./grafics/ufw-netzwerk.png)<br />
Nach der Anmeldung über die Konsole als Benutzer root laden wir die Datei: **ufw.sh** in unser root Verzeichniss.<br />
**Download:**<br />
**_wget -q --show-progress https://github.com/TheoRichter/Schulungsumgebung/blob/main/downloads/ufw.sh_**<br />
Mit dem Aufruf **_bash ufw.sh_** beginnt die Installation.<br />
Nach Beendigung der Installation bitte die Dateien **guac.conf, docker.con** und **pve.conf**<br />
im Ordner /etc/ngnix/sites-available/ auf eure Subdomains Anpassen.<br />
Mit der Eingabe **_certbot_** startet die Installation des Reverse-Proxies.<br />
## Installation von Apache Guacamole
### Neuen LXC-Container mit 1CPU, 2GB RAM und 4GB Festplattenspeicher benötigt. Ausreichend für 25 Benutzer.
### !!!Installierbar leider nur mit Template debian-11-standard_11.7-1_amd64.tar.zst!!!
Nach der Anmeldung über die Konsole als Benutzer root laden wir die Datei: **guac_debian11_install_upgrade_debian12.sh** in unser root Verzeichniss.<br />
**Download:**<br />
**_wget -q --show-progress https://github.com/TheoRichter/Schulungsumgebung/blob/main/downloads/guac_debian11_install_upgrade_debian12.sh_**<br />
Mit dem Aufruf **_bash guac_debian11_install_upgrade_debian12.sh_** beginnt die Installation.<br />
BITTE nach dem Neustart den Status des Tomcat9 mit **_systemctl status tomcat9 --no-pager_**<br />
und den Status des Guacamole-Servers mit **_systemctl status guacd --no-pager_** Überprüfen.<br />
## Installation von Docker
### Neuen LXC-Container mit 7CPUs, 10240GB RAM und 41GB Festplattenspeicher benötigt.
Nach der Anmeldung über die Konsole als Benutzer root laden wir die Datei: **docker-schulungen.sh** in unser root Verzeichniss.<br />
**Download:**<br />
**_wget -q --show-progress https://github.com/TheoRichter/Schulungsumgebung/blob/main/downloads/docker-schulungen.sh_**<br />
Mit dem Aufruf **_bash docker-schulungen.sh_** beginnt die Installation.<br />
## Vorbereitung der Installation von Windows 11
Um Windows 11 zu installieren müssen wir die drei ISOs hier Speichern:<br />
![ISOs](./grafics/ISOs.png)<br />
## Download-Adressen
### Windows 11
https://www.microsoft.com/de-de/software-download/windows11<br />
![Windows11Download](./grafics/Windows11Download.png)<br />
### unattend.iso
https://schneegans.de/windows/unattend-generator/<br />
### virtio-win-0.1.240.iso
https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.240-1/virtio-win-0.1.240.iso<br />
## Installation von Windows 11
Durch das Klicken auf ![VM](./grafics/VM.png) wir eine neue virtuelle Maschine erstellen.<br />
Windows_1<br />
![Windows_1_neu](./grafics/Windows_1_neu.png)<br />
Windows_2<br />
![Windows_2_neu](./grafics/Windows_2_neu.png)<br />
Windows_3<br />
![Windows_3_neu](./grafics/Windows_3_neu.png)<br />
Windows_4<br />
![Windows_4_neu](./grafics/Windows_4_neu.png)<br />
Windows_5<br />
![Windows_5_neu](./grafics/Windows_5_neu.png)<br />
Windows_6<br />
![Windows_6_neu](./grafics/Windows_6_neu.png)<br />
Windows_7<br />
![Windows_7_neu](./grafics/Windows_7_neu.png)<br />
Windows_8<br />
![Windows_8_neu](./grafics/Windows_8_neu.png)<br />
Windows_9<br />
![Windows_9_neu](./grafics/Windows_9_neu.png)<br />
Windows_10<br />
![Windows_10_neu](./grafics/Windows_10_neu.png)<br />
Windows_11<br />
![Windows_11_neu](./grafics/Windows_11_neu.png)<br />
Windows_12<br />
![Windows_12_neu](./grafics/Windows_12_neu.png)<br />
Windows_13<br />
![Windows_13_neu](./grafics/Windows_13_neu.png)<br />
Windows_14<br />
![Windows_14_neu](./grafics/Windows_14_neu.png)<br />
Windows_15<br />
![Windows_15_neu](./grafics/Windows_15_neu.png)<br />
Windows_16<br />
![Windows_16_neu](./grafics/Windows_16_neu.png)<br />
Windows_17<br />
![Windows_17_neu](./grafics/Windows_17_neu.png)<br />
Windows_18<br />
![Windows_18_neu](./grafics/Windows_18_neu.png)<br />
Windows_19<br />
![Windows_19_neu](./grafics/Windows_19_neu.png)<br />
<br />
<br />
<br />
<br />



