#!/bin/sh
if [ $USER = "root" ] ; then
	echo ""
	echo " 1. Fixing default locale problems with LXC containers..."
	echo ""
	
	locale-gen en_US en_US.UTF-8
	
	echo ""
	echo " 2. Updating system..."
	echo ""
	
	apt-get update -y
	
	apt-get upgrade -y

	apt-get dist-upgrade -y
	
	apt-get install -y curl git-core unzip
	
	echo ""
	echo " 3. Installing Apache 2.4..."
	echo ""
	
	echo " 4. Installing PHP 7.0..."
	echo ""
	
	echo " 5. Installing MySQL..."
	echo ""
	
	apt-get install -y apache2 php7.0 mysql-server libapache2-mod-php7.0 php7.0-mysql
	
	echo ""
	read -p " Would you like install phpMyAdmin ? [y/N] " INSTALL_PHPMYADMIN
	echo ""
	
	if [ "$INSTALL_PHPMYADMIN" = "y" ] ; then
		echo " 6. Installing phpMyAdmin..."
		echo ""

		apt-get install -y phpmyadmin
	fi
	
	echo ""
	read -p " Would you like git clone Let's Encrypt from GitHub ? [y/N] " GITCLONE_LETSENCRYPT
	echo ""
	
	if [ "$GITCLONE_LETSENCRYPT" = "y" ] ; then
		echo " 7. Git cloning Let's Encrypt from GitHub..."
		echo ""
	
		cd /opt/
		
		git clone https://github.com/certbot/certbot
	fi
	
	echo ""
	echo " 8. Configuring Apache..."
	echo ""

	cd /etc/apache2/

	mv apache2.conf apache2.conf.default

	wget --quiet https://raw.githubusercontent.com/Punk--Rock/Configuration-files/master/apache2/apache2.conf

	echo " 9. Restarting Apache..."
	echo ""

	service apache2 restart
	
	echo " That's okay !"
	echo ""
else
	echo ""
	echo "You are not root :("
	echo ""
fi
