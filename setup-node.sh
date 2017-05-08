#!/bin/bash

# Linuxissa vaa roottina
if [[ $(whoami) != "root" ]]; then
  echo "Tämä on mahdollista vain roottina"
  exit
fi

echo "Päivitetään kone, yum update..."
yum update -y
echo

echo "Asennetaan Base-paketit..."
yum groupinstall -y Base
echo

echo "Asennetaan openssh-server openssh-clients sudo wget nano..."
yum install -y openssh-server openssh-clients sudo wget nano
echo

echo "Lisätään sshers ja sudoers ryhmät..."
groupadd sshers
groupadd sudoers
echo

echo "Salasana devlab-käyttäjälle. (Kopsaa ja tallenna 1passwordiin)"
openssl rand -base64 21
echo

echo "Lisätään devlab-käyttäjä ja annetaan sille salasana..."
useradd devlab

passwd devlab
usermod -a -G sshers,sudoers devlab
echo

echo "Sallitaan ssh-kirjautuminen vain sshers-ryhmälle..."
echo "AllowGroups sshers" >> /etc/ssh/sshd_config
echo "%sudoers ALL=(ALL) ALL" >> /etc/sudoers
service sshd restart
echo

echo "Luodaan /home/devlab/secret-kansio..."
mkdir /home/devlab/secret
chown devlab:devlab /home/devlab/secret
chmod 0700 /home/devlab/secret
echo

echo "Poistetaan selinux käytöstä..."
echo -e "SELINUX=disabled\nSELINUXTYPE=targeted" > /etc/selinux/config
echo

echo "Valmis... Boottaa kone!"
echo
