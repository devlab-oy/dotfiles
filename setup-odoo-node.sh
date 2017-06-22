#!/bin/bash

# Linuxissa vaa roottina
if [[ $(whoami) != "root" ]]; then
  echo "Tämä on mahdollista vain roottina"
  exit
fi

echo "Päivitetään kone, apt-get update..."
apt-get update
apt-get upgrade -y
echo

echo "Asennetaan Base-paketit..."
yum groupinstall -y Base
echo

echo "Asennetaan openssh-server openssh-clients sudo wget nano..."
apt-get install -y openssh-server openssh-client sudo wget nano
echo

echo "Lisätään sshers ja sudoers ryhmät..."
groupadd sshers
groupadd sudoers
echo

echo "Salasana odoo-käyttäjälle. (Kopsaa ja tallenna 1passwordiin)"
openssl rand -base64 21
echo

echo "Lisätään odoo-käyttäjä ja annetaan sille salasana..."
useradd -m odoo

passwd odoo
usermod -a -G sshers,sudoers odoo
echo

echo "Vaihdetaan odoo-käyttäjän shelli bashiksi..."
chsh -s /bin/bash odoo
echo

echo "Sallitaan ssh-kirjautuminen vain sshers-ryhmälle..."
echo "AllowGroups sshers" >> /etc/ssh/sshd_config
echo "%sudoers ALL=(ALL) ALL" >> /etc/sudoers
service sshd restart
echo

echo "Luodaan /opt/odoo/secret-kansio..."
mkdir /home/odoo/secret
chown odoo:odoo /home/odoo/secret
chmod 0700 /home/odoo/secret
echo

echo "Valmis... Boottaa kone!"
echo
