#!/bin/sh
if [ "$USER" = "root" ] ; then
	echo " Fixing default system's locale..."
	
	locale-gen en_US en_US.UTF-8 > /dev/null

	echo " Updating system..."
	
	apt-get update > /dev/null
	
	apt-get upgrade > /dev/null

	apt-get dist-upgrade > /dev/null
	
	apt-get install curl unzip > /dev/null
	
	echo " Installing MySQL..."

	apt-get install mysql-server mysql-client
	
	echo " Installing Nginx..."

	apt-get install nginx > /dev/null

	echo " Installing PHP 7.0 FPM and other PHP 7.0 components..."
	
	apt-get install php7.0-fpm php7.0-* > /dev/null
	
	read -p "Would you like install phpMyAdmin ? [y/N]" INSTALL_PHPMYADMIN
	
	if [ "$INSTALL_PHPMYADMIN" = "y" ] ; then
		echo " Installing phpMyAdmin..."

		apt-get install phpmyadmin
		
		ln -s /usr/share/phpmyadmin/ /var/www/html/
	fi

	read -p "Would you like git clone Let's Encrypt from GitHub ? [y/N]" GITCLONE_LETSENCRYPT
	
	if [ "$GITCLONE_LETSENCRYPT" = "y" ] ; then
		echo " Installing git-core..."
		
		apt-get install git-core > /dev/null
		
		echo " git cloning Let's Encrypt from GitHub..."
	
		cd /opt/
		
		git clone https://github.com/letsencrypt/letsencrypt > /dev/null
	fi
	
	echo " Configuring Nginx..."

	cd /etc/nginx/

	mv nginx.conf nginx.conf.default

	wget https://raw.githubusercontent.com/Punk--Rock/Configuration-files/master/nginx/nginx.conf
	
	if [ "$INSTALL_PHPMYADMIN" = "y" ] ; then
	
		echo " Downloading Nginx default server block with phpMyAdmin..."

		cd sites-available/

		wget https://raw.githubusercontent.com/Punk--Rock/Configuration-files/master/nginx/sites-available/default.conf

		cd ../sites-enabled/

		rm default

		ln -s /etc/nginx/sites-available/default.conf
	else
		# echo " ";
		
		cd sites-available/
		
		cp default default.conf
		
		cd ../sites-enabled/
		
		rm default
		
		ln -s /etc/nginx/sites-available/default.conf
	fi
	
	echo " Configuring PHP 7.0 FPM..."

	cd /etc/php/7.0/fpm/pool.d/

	mv www.conf www.conf.default

	wget https://raw.githubusercontent.com/Punk--Rock/Configuration-files/master/php/7.0/fpm/pool.d/www.conf
	
	echo " Restarting Nginx and PHP 7.0 FPM..."

	service nginx restart && service php7.0-fpm restart
	
	echo " Done !"
else
	echo "You are not root :("
fi
