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

# PROXMOX auf einem Internet-Server installieren.
Die jeweilge intallation des Linux: Debian 12 "brookworm" hängt von dem Mietserver-Betreiber ab.<br /> 
Nach der Installation melden wir uns per Textconsole mit der Eingabe **_ssh root@Die-IP-Addresse_** am Server an.<br /> 
Aktualisieren, Installieren und Neustarten des Debian 12 mit der Eingabe.<br />
**_apt update && apt upgrade -y && apt autoremove -y && apt install -y mc_**
## Anpassen der Datei /etc/hostname und der Datei /etc/hosts
Mit **_mcedit /etc/hosts_** ändern wir die Eintragung<br />
**Die-IP-Addresse Debian-bookworm-latest-amd64-base** in **Die-IP-Addresse pve.deine-domain pve**<br />
und ändern die Zeile **127.0.0.1 localhost** in **127.0.0.1 localhost.localdoain localhost**<br />
Mit **_mcedit /etc/hostname_** ändern wir die Eintragung **Debian-bookworm-latest-amd64-base** in **pve**<br />
# !!! ACHTUNG nur bei einem STRATO-Server !!!
Um Proxmox installieren zukönnen müßen wir Änderungen in **/etc/networks/interfaces** vornehmen.<br />
Mit dem Befehl **_ip a_** finden wir die Netzwerkeinstellungen:<br />
![ipa](./grafics/ipa.png)<br />
Unsere Netzwerkschnittstelle heißt **eno1** die IP-Addresse ist: **81.169.138.128** mit der Subnetmaske: **255.255.255.255** oder **/32**.<br />
Mit dem Befehl **_ip r_** ermitten wir den gateway.<br />
![iproute](./grafics/iproute.png)<br />
Unser Gateway ist 81.169.138.1<br />
Neustart des System mit der Eingabe **_systemctl reboot_**.<br />


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
Auf unserem Windows PC öffnen wir einen Browser und geben die IP-Address unserer Proxmox VE ein.<br />
https://Die-IP-Addresse:8006<br />
Wenn alles geklappt erscheint diese Bildschirmausgabe.<br />
![ProxmoxVElogin](./grafics/ProxmoxVElogin.png)<br />
## Hier die Eingabe Daten der ersten Anmeldung
![ProxmoxErsteAnmeldung](./grafics/ersteAnmeldung.png)<br />
## Netzwerkeinstellungen
### Schritt 1:
Erstellen der Linux Bridge vmbr0 mit der IP 10.1.0.2/24 und der Linux Bridge vmbr1 mit der IP 10.0.0.0/31<br />
![LinuxBridge](./grafics/LinuxBridge.png)<br>
#### Ergänzungen in der in der Datei /etc/network/interfaces <br />
Eintragungen /etc/network/interfaces **VORHER**<br />
![interfaces_vmbrs](./grafics/interfaces_hetzner_vmbrs.png)<br />
Mit **_mcedit /etc/network/interfaces_** ändern wir die Eintragungen wie untenstehend ab.<br />
Eintragungen /etc/network/interfaces **NACHHER**<br />
**_!!!BITTE DIE NETZWERK-ANGABEN DEM ENTSPRECHEND ANPASSEN!!!!_**<br />
![interfaces_fertig](./grafics/interfaces_hetzner_fertig.png)<br />







<br />
<br />
<br />



