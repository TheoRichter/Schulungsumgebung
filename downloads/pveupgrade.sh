#!/bin/sh
############################################################
#                                                          #
#                 PVEUdate und PVEUpgrade                  #
#                                                          #
############################################################

#   PveUpdate und PveUpgrade=(dist-upgrade) wir gestartet  #
echo
echo "PveUdate, PveUpgrade=(dist-upgrade) und autoremove wird gestartet"
echo
pveupdate && apt-get dist-upgrade -y && apt-get autoremove -y

#                  Ausgabe der Status Meldung              #
echo
echo "PveUpdate, PveUpgrde=(dist-dpgrade) und autoremove wird bendet"
echo
