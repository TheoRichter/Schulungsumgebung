# PROXMOX auf einem Internet-Server installieren.
### Die jeweilge intallation des Linux: Debian 12 "brookworm" hängt von dem Mietserver-Betreiber ab.
Nach der Installation melden wir uns per Textconsole mit der Eingabe **_ssh root@DIE-IP-ADDRESSE_** am Server an.<br /> 
Aktualisieren, Installieren und Neustarten des Debian 12 mit der Eingabe.<br />
**_apt update && apt upgrade -y && apt autoremove -y && apt install -y mc curl htop lsof ethtool ifupdown2 && systemctl reboot_**<br />
### Ändern der Netzwerkeinstellung bei HETZNER.
Jetzt <br />
![interfaces_org](./grafics/interfaces_hetzner_org.png)<br>

<br />
<br />





![interfaces_vmbrs](./grafics/interfaces_hetzner_vmbrs.png)<br>
![interfaces_fertig](./grafics/interfaces_hetzner_fertig.png)<br>

### Ändern der Netzwerkeinstellung bei STRATO.
<br />
<br />
<br />







































__wget__ https://github.com/TheoRichter/Schulungsumgebung/blob/main/1-INSTALLATION/downloads/interfaces_hetzner