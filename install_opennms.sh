#!/bin/bash


# Must run the script as root or sudo-user. Tells the user this. 
echo "Before proceeding, this script that installs OpenNMS must be run using the sudo command or as the root" 

# Prompt to exit or continue. 
echo "Do you wish to continue running the script? (y/n): "
read user_answer

if [ "$user_answer" == "y" ] || [ "$user_answer" == "Y" ]; then
	# Update the machine
	yum -y update

	# Install the postgresql Repository
	yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

	# Install postgresql-12
	yum -y install postgresql12-server postgresql12

	# Initialize postgresql-12
	/usr/pgsql-12/bin/postgresql-12-setup initdb
      
	# Enable postgresql-12
	systemctl enable --now postgresql-12

	# Create new postgresql user "opennms"
	sudo -i -u postgres psql -c "CREATE USER opennms WITH PASSWORD 'opennms';" 

	# Create postgres database for user opennms
	sudo -i -u postgres createdb -O opennms opennms

	# Change password for the postgres sudo user 
	sudo -i -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"

 	# Editing postgresql-12 file hashing 
	sed '86 s/ident/md5/' /var/lib/pgsql/12/data/pg_hba.conf
 	sed '88 s/ident/md5/' /var/lib/pgsql/12/data/pg_hba.conf

	# Reload postgresql-12
	systemctl reload postgresql-12

	# Install opennms repository
	yum -y install https://yum.opennms.org/repofiles/opennms-repo-stable-rhel7.noarch.rpm

	# Import opennms
	rpm --import https://yum.opennms.org/OPENNMS-GPG-KEY

	# Install opennms
	yum -y install opennms

	# Install epel-release
	yum -y install epel-release

	# Install R-core
	yum -y install R-core

	# Install yum-utils
	yum -y install yum-utils

	# Disable opennms automatic updates
	yum-config-manager --disable opennms-repo-stable-*

 	# Editing credentials
  	-u opennms sed /opt/opennms/etc/opennms-datasources.xml

	# Setting up Java
	/opt/opennms/bin/runjava -s
	/opt/opennms/bin/install -dis

	# Enable opennms
	systemctl enable --now opennms

	# Add masquerade to the firewall
	firewall-cmd --permanent --add-masquerade

	# Add port 8980/tcp to the firewall 
	firewall-cmd --permanent --add-port=8980/tcp

	# Add port 162/udp to the firewall 
	firewall-cmd --permanent --add-port=162/udp

	# Add port 10162/udp to the firewall
	firewall-cmd --permanent --add-port=10162/udp

	# Fowarding port 162/udp to 10162/udp
	firewall-cmd --permanent --add-forward-port=port=162:proto=udp:toport=10162

	# Reload the firewall
	systemctl reload firewalld

	echo "OpenNMS and its dependencies has been installed successfully." 
	echo "Please edit the two listed files below with the new credentials for the users created in this script and the hash md5 for local ipv4/6. After, reload opennms and postgresql-12"
	echo "You can cat this file to read the defaults."
	echo "1) sudo vi /var/lib/pgsql/12/data/pg_hba.conf 2) -u opennms vi /opt/opennms/etc/opennms-datasources.xml"
	
else
    echo "Exiting the script without installing OpenNMS." 
fi
