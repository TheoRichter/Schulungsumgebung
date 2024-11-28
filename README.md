# Aufagbenstellung
Erstellen einer  Online Schulungsmöglichkeit bestehend aus Windows und Linux Betriebs-Systemen.
# L&ouml;sungsansatz
![PROXMOX_VE](./1-INSTALLATION/grafics/pve_logo.png)

**Firmeninformation**<br> 
**Firma:** Proxmox Server Solutions GmbH<br> 
**Adresse:** Bräuhausgasse 37, 1050 Vienna, Austria<br> 

E-Mail: office@proxmox.com

https://www.proxmox.com

**Firmenbuchnummer:** FN 258879f<br> 
**Firmenbuchgericht:** Handelsgericht Wien<br>
**Geschäftsführer:** Martin Maurer, Tim Marx<br> 

UID-Nr.: ATU 61587900

# PROXMOX auf einem HETZNER-Server installieren.
Die jeweilge intallation des Linux: Debian 12 "brookworm" hängt von dem Mietserver-Betreiber ab.<br /> 
Nach der Installation melden wir uns per Textconsole mit der Eingabe **_ssh root@DIE-IP-ADDRESSE_** am Server an.<br /> 
Aktualisieren, Installieren und Neustarten des Debian 12 mit der Eingabe.<br />
**_apt update && apt upgrade -y && apt autoremove -y && apt install -y mc curl htop lsof ethtool ifupdown2 && systemctl reboot_**
## SSH-Dienst absichern
Jetz legen wir mit **_useradd -m {Benutzername}_** einen neuen Benutzer an, und mit **_passwd {Benutzername}_** erstellen wir das Passwort.<br />
Sicherungskopie der Originalen sshd_config Datei erstellen **_cp /etc/ssh/{sshd_config,sshd_config.orig}_**<br />
Um nur ausgewählten Benutzern den Zugung über den SSH-Dienst zu erlauben, erstellen wir mit groupadd sshgroup_** die neue Gruppe mit Namen sshgroup.<br />
Mit der Eingabe (_Bitte nicht Kopieren!!_) **_usermod –a -G sshgroup {Benutzername}_** weisen wir den Benutzer der **sshgroup** zu.<br />
Löschen der vom System automatisch erstellte SSH-Key mit Befehl **_rm /etc/ssh/ssh_host_*_**<br />
SSH-Key ed25519 erstellen **_ssh-keygen -o -a 9999 -t ed25519 -N "" -f /etc/ssh/ssh_host_ed25519_key -C "$(whoami)@$(hostname)-$(date -I)"_**<br />
SSH-Key rsa erstellen **_ssh-keygen -o -a 9999 -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key -C "$(whoami)@$(hostname)-$(date -I)"_**<br />
Download der neuen SSH-Serverkonfiguration: sshd_config<br />
**_wget http://web.webolch.de/bauanleitung/downloads/linux/pve.svws.nrw/etc/ssh/sshd_config_**<br />
**_mv sshd_config /etc/ssh/_**<br />
Nach dem Download überschreiben wir den alten Inhalt der Datei im Verzeichniss /etc/ssh/sshd_config.<br />
SSH-Dienst restarten: **_systemctl restart ssh_**<br />
Status SSH-Dienst überpüfen: **_systemctl status --lines=20 ssh_**<br />
<br />


Mit der Eingabe **_ _** <br />
![interfaces_org](./grafics/interfaces_hetzner_org.png)<br>
![interfaces_vmbrs](./grafics/interfaces_hetzner_vmbrs.png)<br>
![interfaces_fertig](./grafics/interfaces_hetzner_fertig.png)<br>






# PROXMOX auf einem STRATO-Server installieren.
Ändern der Netzwerkeinstellung bei STRATO.<br />

<br />
<br />
<br />



