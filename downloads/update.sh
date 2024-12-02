#!/bin/sh
##############################################################
#                                                            #
#       Update, Upgrade ud Autoremove                        #
#                                                            #
##############################################################

#   Update, Upgrade ud Autoremove wir gestartet              #
echo
echo "Update, Upgrade ud Autoremove wir gestartet"
echo
apt update && apt upgrade -y && apt autoremove -y

#                  Ausgabe der Status Meldung                #
echo
echo "Update, Upgrade ud Autoremove wir gestartet wird bendet"
echo
