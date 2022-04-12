#!/bin/bash

###########################################################
# Read IP-adresses
###########################################################

echo "Wat is het IP-adres van de huidige VM (Master):"
read IPMASTER
echo "Wat is het IP-adres van GameServer1:"
read IPSERVER1
echo "Wat is het IP-adres van GameServer2:"
read IPSERVER2

#############################################################
# generate ssh-key for root user and copy it to CentosServers
#############################################################

ssh-keygen

USER="root"

for HOST in $IPSERVER1 $IPSERVER2
do

    #transfering public key to all servers
    ssh-copy-id -i ~/.ssh/id_rsa.pub $USER@$HOST
    echo -e "\n\n ssh-keys geinstalleerd op $HOST \n\n"

done

#############################################################
# set hostname master
#############################################################

hostnamectl set-hostname ScriptMaster

#############################################################
# update /etc/hosts toe resolve servers
#############################################################

cat << EOF >> /etc/hosts
$IPMASTER     ScriptMaster  
$IPSERVER1    GameServer01  
$IPSERVER2    GameServer02  
EOF

#############################################################
# copy /etc/hosts to other servers
#############################################################

for HOST in "GameServer01" "GameServer02"
do
    scp /etc/hosts $HOST:/etc/hosts
    ssh $HOST "hostnamectl set-hostname $HOST"
done

#############################################################
# reboot master so new hostname is set
#############################################################

reboot





