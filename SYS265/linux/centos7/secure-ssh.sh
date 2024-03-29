#!/bin/bash

# secure-ssh.sh
# author savannahc502
# adds a public key from the local repo or curled from the remote repo 
# removes roots ability to ssh in

# Creates a user and adds the public key
sudo useradd -m -d /home/${1} -s /bin/bash ${1}
sudo mkdir /home/${1}/.ssh
cd /home/savannah/SavC-TechJournal-SYS265
sudo cp SYS265/linux/public-keys/id_rsa.pub /home/${1}/.ssh/authorized_keys
sudo chmod 700 /home/${1}/.ssh
sudo chmod 600 /home/${1}/.ssh/authorized_keys
sudo chown -R ${1}:${1} /home/${1}/.ssh

# Blocking root ssh login
if grep -q "^PermitRootLogin" /etc/ssh/sshd_config; then
   sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
else
   echo "PermitRootLogin not found in /etc/ssh/sshd_config"
fi

# Restart SSH
sudo systemctl restart sshd.service
