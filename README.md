# Aufgabenstellung
Erstellen einer  Online Schulungsmöglichkeit bestehend aus Windows und Linux Betriebs-Systemen.
# Lösungsansatz
![PROXMOX](./grafics/proxmox_logo.png)
<!-- ![PROXMOX](https://www.proxmox.com/images/proxmox/Proxmox_logo_standard_hex_200px.png) -->

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
Aktualisieren und Installieren des Debian 12 mit der Eingabe.<br />
**_apt update && apt upgrade -y && apt autoremove -y && apt install -y mc_**
_Anpassen der Datei /etc/hosts und der Datei /etc/hostname (bei HETZNER)_<br />
Mit **_mcedit /etc/hosts_** ändern wir die Eintragung<br />
**Die-IP-Adresse Debian-bookworm-latest-amd64-base** in **Die-IP-Adresse pve.deine-domain pve**<br />
und ändern die Zeile **127.0.0.1 localhost** in **127.0.0.1 localhost.localdoain localhost**<br />
Mit **_mcedit /etc/hostname_** ändern wir die Eintragung **Debian-bookworm-latest-amd64-base** in **pve**<br />
_Anpassen der Datei /etc/hosts und der Datei /etc/hostname (bei STRATO)_<br />
Mit **_mcedit /etc/hosts_** ändern wir die Eintragung<br />
**127.0.1.1 h3014859.stratoserver.net h3014859** in **Die-IP-Adresse pve.deine-domain pve**<br />
und ändern die Zeile **127.0.0.1 localhost** in **127.0.0.1 localhost.localdoain localhost**<br />
Mit **_mcedit /etc/hostname_** ändern wir die Eintragung **h3014859.stratoserver.net h3014859** in **pve**<br />
# !!! ACHTUNG nur bei einem STRATO-Server !!!
**ANFANG: Änderungen für den STRATO-Server** <br />
Um Proxmox installieren zukönnen müßen wir Änderungen in **/etc/networks/interfaces** vornehmen.<br />
Mit dem Befehl **_ip a_** finden wir die Netzwerkeinstellungen:<br />
![ip-a](./grafics/ip-a.png)<br />
Unsere Netzwerkschnittstelle heißt **eno1** die IP-Addresse ist: **xxx.xxx.xxx.xxx** mit der Subnetmaske: **255.255.255.255** oder **/32**.<br />
Mit dem Befehl **_ip r_** ermitteln wir den gateway.<br />
![iproute](./grafics/iproute.png)<br />
Unser Gateway wird angezeigt<br />
Eintragungen ** /etc/network/interfaces VORHER**<br />
![interfaces_vorher](./grafics/interfaces_vorher.png)<br />
Mit **_mcedit /etc/network/interfaces_** ändern wir die Eintragungen wie untenstehend ab.<br />
Eintragungen **/etc/network/interfaces NACHHER**<br />
**_!!!BITTE DIE NETZWERK-ANGABEN DEM ENTSPRECHEND ANPASSEN!!!!_**<br />
![interfaces_nachher](./grafics/interfaces_nachher.png)<br />
**ENDE: Änderungen für den STRATO-Server**<br />
**Jetzt starten wir des System mit der Eingabe _systemctl reboot_ neu.**<br />
_SSH-Dienst absichern_<br />
Jetz legen wir mit **_useradd -m {Benutzername}_** einen neuen Benutzer an, und mit **_passwd {Benutzername}_** erstellen wir das Passwort.<br />
Sicherungskopie der Originalen sshd_config Datei erstellen **_cp /etc/ssh/{sshd_config,sshd_config.orig}_**<br />
Um nur ausgewählten Benutzern den Zugung über den SSH-Dienst zu erlauben, erstellen wir mit groupadd sshgroup_** die neue Gruppe mit Namen sshgroup.<br />
Mit der Eingabe (_Bitte nicht Kopieren!!_) **_usermod –a -G sshgroup {Benutzername}_** weisen wir den Benutzer der **sshgroup** zu.<br />
Löschen der vom System automatisch erstellte SSH-Key mit Befehl **_rm /etc/ssh/ssh_host_***<br />
SSH-Key ed25519 erstellen **_ssh-keygen -o -a 9999 -t ed25519 -N "" -f /etc/ssh/ssh_host_ed25519_key -C "$(whoami)@$(hostname)-$(date -I)"_**<br />
SSH-Key rsa erstellen **_ssh-keygen -o -a 9999 -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key -C "$(whoami)@$(hostname)-$(date -I)"_**<br />
Download der neuen SSH-Serverkonfiguration: sshd_config<br />
**_wget https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/sshd_config_**<br />
**_mv sshd_config /etc/ssh/_**<br />
Nach dem Download überschreiben wir den alten Inhalt der Datei im Verzeichniss /etc/ssh/sshd_config.<br />
SSH-Dienst restarten: **_systemctl restart ssh_**<br />
Status SSH-Dienst überpüfen: **_systemctl status --lines=20 ssh_**
_Vorbereitung der Proxmox Installation._<br />
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
Entfernen des Debian-Kernels mit dem Befehl ___apt remove linux-image-amd64 'linux-image-6.1*'___<br />
_Anmeldung bei der Proxmox VE_<br />
Auf unserem Windows PC öffnen wir einen Browser und geben die IP-Adresse unserer Proxmox VE ein.<br />
https://Die-IP-Addresse:8006<br />
Wenn alles geklappt erscheint diese Bildschirmausgabe.<br />
![ProxmoxVElogin](./grafics/ProxmoxVElogin.png)<br />
_Hier die Eingabe Daten der ersten Anmeldung_<br>
![ProxmoxErsteAnmeldung](./grafics/ersteAnmeldung.png)<br />
_Netzwerkeinstellungen_<br />
Erstellen der Linux Bridge vmbr0 mit der IP 10.1.0.2/24 und der Linux Bridge vmbr1 mit der IP 10.0.0.0/31<br />
![LinuxBridge](./grafics/LinuxBridge.png)<br>
_Ergänzungen in der in der Datei /etc/network/interfaces_<br />
Eintragungen **HETZNER /etc/network/interfaces VORHER**<br />
![interfaces_vmbrs](./grafics/interfaces_hetzner_vmbrs.png)<br />
Eintragungen **STRATO /etc/network/interfaces VORHER**<br />
![stratopve_interfaces_vorher](./grafics/stratopve_interfaces_vorher.png)<br />
Mit **_mcedit /etc/network/interfaces_** ändern wir die Eintragungen wie untenstehend ab.<br />
Eintragungen **/etc/network/interfaces NACHHER**<br />
**_!!!BITTE DIE NETZWERK-ANGABEN DEM ENTSPRECHEND ANPASSEN!!!!_**<br />
![interfaces_fertig](./grafics/interfaces_hetzner_fertig.png)<br />
_Vorbereitung der Installation von LXC-Containern_
Um LXC-Container zu Erstellen müssen wir die zwei Templates hier Speichern:<br />
![Templates](./grafics/Templates.png)<br />
## Installation der UFW mit Certbot (Reverse-Proxy)
_Neuen LXC-Container mit 1CPU, 512KiB RAM und 2GB Festplattenspeicher benötigt._<br />
![ufw-netzwerk](./grafics/ufw-netzwerk.png)<br />
Nach der Anmeldung über die Konsole als Benutzer root laden wir die Datei: **ufw.sh** in das root Verzeichniss.<br />
**Download:**<br />
**_wget -q --show-progress https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/ufw.sh_**<br />
Mit dem Aufruf **_bash ufw.sh_** beginnt die Installation.<br />
Bei der Eingabe von https://Die-IP-Addresse:8006 im Browser erscheint diese Melung.<br />
![sichereVerbindung](./grafics/sichereVerbindung.png)<br />
Mit **certbot** wird diese Meldung verhindert.<br />
Hier werden die drei Datein im Ordner **/etc/ngnix/sites-available/** und die Links im Ordner **/etc/nginx/sites-enabled/** angezeigt.<br />
![certbot](./grafics/certbot.png)<br />
Im Ordner **/etc/ngnix/sites-available/** befinden sich diese drei Dateien.<br />
**Bitte in der Spalte den Eintrag hinter server_name durch Ihre Subdomain Ersetzen.**<br />
| docker.conf | guac.conf | pve.conf |
| :---        | :---      | :---     |
| server {    | server {  | server { |
| server_name docker.subdomain.de; | server_name guac.subdomain.de; | server_name pve.subdomain.de; |
| location / {  | location / {  | location / {  |
| proxy_pass      https://10.1.0.3:9443; | proxy_pass      https://10.1.0.4:3000; | proxy_pass      https://10.1.0.2:8006; |
| }    | }    | }    |
|      |      |      |
| proxy_set_header HOST $host; | proxy_set_header HOST $host;  | proxy_set_header HOST $host;  |
| proxy_set_header X-REAL-IP $remote_addr; | proxy_set_header X-REAL-IP $remote_addr; | proxy_set_header X-REAL-IP $remote_addr; |
| proxy_set_header X-Forward-For $proxy_add_x_forwarded_for; | proxy_set_header X-Forward-For $proxy_add_x_forwarded_for; | proxy_set_header X-Forward-For $proxy_add_x_forwarded_for; |
|       |       |       |
| proxy_set_header Upgrade $http_upgrade; | proxy_set_header Upgrade $http_upgrade; | proxy_set_header Upgrade $http_upgrade; |
| proxy_http_version 1.1; | proxy_http_version 1.1;  | proxy_http_version 1.1; |
| proxy_set_header Connection "upgrade"; | proxy_set_header Connection "upgrade"; | proxy_set_header Connection "upgrade"; |
|       |       |       |
| listen 80; | listen 80; | listen 80; |
| listen [::]:80; | listen [::]:80; | listen [::]:80;  |
|     |     |     |
| }   | }   | }   |

Mit der Eingabe **_certbot_** startet die Installation des Reverse-Proxies.<br />
![certbot_1](./grafics/certbot_email.png)<br />
Nach der Eingabe der Email-Addresse drücken wir Enter.<br />
![certbot_2](./grafics/certbot_email_Yes.png)<br />
Nach der Eingabe von **Y** mit Enter bestätigen.<br />
![certbot_3](./grafics/certbot_email_Yes_Yes.png)<br />
Ich habe auch **Y** eingegeben und mit Enter bestätigen. (Es geht bestimmt auch **N** dann gibt es keine Mails!)<br />
![certbot_4](./grafics/Certbot_HTTPS.png)<br />
Hier stehen Ihr eingeben Subdomains.<br />
![certbot_5](./grafics/certbot_https_successfully.png)<br />
Bei der Eingabe von https://ihre-subdomain.de im Browser erschien die obige Melung jetzt nicht mehr.<br />
Als Beispiel hier mal https://stratopve.webolchi.de<br />
## Installation von Docker
_Neuen LXC-Container mit 7CPUs, 10240GB RAM und 41GB Festplattenspeicher benötigt._<br />
![docker-netwerk](./grafics/docker-netwerk.png)<br />
Nach der Anmeldung über die Konsole als Benutzer root laden wir die Datei: **docker-schulungen.sh** in das root Verzeichniss.<br />
![docker_login](./grafics/docker_login.png)<br />
**Download:**<br />
**_wget -q --show-progress https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/docker-schulungen.sh_**<br />
Mit **_bash docker-schulungen.sh_** beginnt die Installation <br />
![docker_bash-docker-schulungen-sh](./grafics/docker_bash-docker-schulungen-sh.png)<br />
Mit OK bestätigen.<br />
![docker_bash-docker-schulungen-sh-1](./grafics/docker_bash-docker-schulungen-sh-1.png)<br />
Mit OK bestätigen.<br />
![docker_bash-docker-schulungen-sh-2](./grafics/docker_bash-docker-schulungen-sh-2.png)<br />
Nach der Bestätigung mit OK müßte es jetzt so aussehen.<br />
![docker_bash-docker-schulungen-sh-3](./grafics/docker_bash-docker-schulungen-sh-3.png)<br />
Inhalt der Datei: schulungen-erklaerung.txt<br /> 
![schulungen-erklaerung](./grafics/schulungen-erklaerung.png)<br />
Nach der Anpassung der Datei **schulungen.txt** geben wir **_bash docker-container-schulungen.sh_** um mit der Installation fortzufahren.<br />
![docker_bash-docker-schulungen-sh-4](./grafics/docker_bash-docker-schulungen-sh-4.png)<br />
Mit der Eingabe **docker start portainer** starten wir den Portainer.<br />
Die Benutzeroberfläche von dem Portainer ist (wenn mit Certbot aktiviert) über folgende Url: **docker.subdomain.de** erreichbar.<br />
Beim ersten Aufruf der GUI muss ein Passwort mit 12 Zeichen vergeben werden.<br>
![portainer-1](./grafics/portainer-1.png)<br />
![portainer-2](./grafics/portainer-2.png)<br />
![portainer-3](./grafics/portainer-3.png)<br />
Um die SVWS-Server zu nutzen müssen wir die Container starten.
![portainer-4](./grafics/portainer-4.png)<br />

_SVWS-Server updaten_<br />
**docker-compose.yml:**<br />

version: "3.9"<br />
services:<br />
  svws-server:<br />
    image: svwsnrw/svws-server:**[Neue Versionsnummer Eintragen]**<br />
    ports:<br />
      - "10001:8443"<br />
    environment:<br />
      MariaDB_HOST: "${MariaDB_HOST}"<br />
      MariaDB_ROOT_PASSWORD: "${MariaDB_ROOT_PASSWORD}"<br />
      MariaDB_DATABASE: "${MariaDB_DATABASE}"<br />
      MariaDB_USER: "${MariaDB_USER}"<br />
      MariaDB_PASSWORD: "${MariaDB_PASSWORD}"<br />
      SVWS_TLS_KEY_ALIAS: "${SVWS_TLS_KEY_ALIAS}"<br />
      SVWS_TLS_KEYSTORE_PATH: "${SVWS_TLS_KEYSTORE_PATH}"<br />
      SVWS_TLS_KEYSTORE_PASSWORD: "${SVWS_TLS_KEYSTORE_PASSWORD}"<br />
    volumes:<br />
      - [path to keystore]:/etc/app/svws/conf/keystore<br />
Aktualisieren mit **_docker pull svwsnrw/svws-server_** in dem jeweiligen Verzeichniss.<br />

## Installation von Apache Guacamole
_Neuen LXC-Container mit 1CPU, 2GB RAM und 4GB Festplattenspeicher benötigt. Ausreichend für 25 Benutzer._<br />
![guac-netzwerk](./grafics/guac-netzwerk.png)<br />
_!!!Installierbar leider nur mit Template debian-11-standard_11.7-1_amd64.tar.zst!!!_
Nach der Anmeldung über die Konsole als Benutzer root laden wir die Datei: **guac_debian11_install_upgrade_debian12.sh** in das root Verzeichniss.<br />
**Download:**<br />
**_wget -q --show-progress https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/guac_debian11_install_upgrade_debian12.sh_**<br />
Mit dem Aufruf **_bash guac_debian11_install_upgrade_debian12.sh_** beginnt die Installation.<br />
BITTE nach dem Neustart den Status des Tomcat9 mit **_systemctl status tomcat9 --no-pager_**<br />
und den Status des Guacamole-Servers mit **_systemctl status guacd --no-pager_** Überprüfen.<br />
Die Benutzeroberfläche von von Apache Guacamole ist (wenn mit Certbot aktiviert) über folgende Url: **guac.subdomain.de** erreichbar.<br />

## Vorbereitung der Installation von Windows 11
Um Windows 11 zu installieren müssen wir die drei ISOs hier Speichern:<br />
![ISOs](./grafics/ISOs.png)<br />
<br />
_Download-Adresse **Windows 11**:_ https://www.microsoft.com/de-de/software-download/windows11<br />
![Windows11Download](./grafics/Windows11Download.png)<br />
<br />
_Download-Adresse **unattend.iso**:_ https://schneegans.de/windows/unattend-generator/<br />
<br />
_Download-Adresse **virtio-win-0.1.240.iso**:_ https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.240-1/virtio-win-0.1.240.iso<br />
## Installation von Windows 11
Mit ![VM](./grafics/VM.png) wir eine neue virtuelle Maschine erstellt.<br />
**Die Angaben für VM ID: und Name: bitte Anpassen.**<br />
![Windows_1_neu](./grafics/Windows_1_neu.png)<br />
![Windows_2_neu](./grafics/Windows_2_neu.png)<br />
![Windows_3_neu](./grafics/Windows_3_neu.png)<br />
**Bei Disk-Größe(GiB): die Zahl 26 auf die Zahl 41 Ändern.**<br />
![Windows_4_neu](./grafics/Windows_4_neu.png)<br />
![Windows_5_neu](./grafics/Windows_5_neu.png)<br />
![Windows_6_neu](./grafics/Windows_6_neu.png)<br />
![Windows_7_neu](./grafics/Windows_7_neu.png)<br />
![Windows_8_neu](./grafics/Windows_8_neu.png)<br />
![Windows_10_neu](./grafics/Windows_10_neu.png)<br />
![Windows_11_neu](./grafics/Windows_11_neu.png)<br />
![Windows_12_neu](./grafics/Windows_12_neu.png)<br />
![Windows_13_neu](./grafics/Windows_13_neu.png)<br />
**Hier steht dann bei Gesamtgröße 41.0 GB und bei Freier Speich: 41.0 GB**<br />
![Windows_14_neu](./grafics/Windows_14_neu.png)<br />
![Windows_15_neu](./grafics/Windows_15_neu.png)<br />
![Windows_16_neu](./grafics/Windows_16_neu.png)<br />
![Windows_17_neu](./grafics/Windows_17_neu.png)<br />
![Windows_18_neu](./grafics/Windows_18_neu.png)<br />
![Windows_19_neu](./grafics/Windows_19_neu.png)<br />
## Automatisches Update und Upgrade
![pve_logo](./grafics/pve_logo.png)<br />
Download der Dateien **_pveupgrade.sh_** und **_reboot.sh_**:<br /> 
**_wget -q --show-progress https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/pveupgrade.sh_**<br />
**_wget -q --show-progress https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/reboot.sh_**<br />
in das Verzeichniss: **/usr/local/sbin** und Eintragung der folgenden Zeilen in die Datei **/etc/[crontab](./downloads/crontab_pve)**<br />
**1 1	* * *	root	/usr/local/sbin/pveupgrade.sh**<br />
**1 3	1 1,2,3,4,5,6,7,8,9,10,11,12 *	root	/usr/local/sbin/reboot.sh**<br />
<br>
![ufw_logo](./grafics/ufw_logo.png), ![docker_logo](./grafics/docker_logo.png) und ![guac_logo](./grafics/guac_logo.png)<br />
Download der Datei **_update.sh_**:<br /> 
**_wget -q --show-progress https://raw.githubusercontent.com/TheoRichter/Schulungsumgebung/refs/heads/main/downloads/update.sh_**<br />
in das Verzeichniss: **/usr/local/sbin** und Eintragung der Zeile in die Datei **/etc/[crontab](./downloads/crontab_lxc)**<br />
**1 1	* * *	root	/usr/local/sbin/update.sh**<br />




