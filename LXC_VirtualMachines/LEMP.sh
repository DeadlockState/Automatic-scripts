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
	echo " 3. Installing MySQL..."
	echo ""

	apt-get install -y mysql-server mysql-client
	
	echo ""
	echo " 4. Installing Nginx..."
	echo ""

	apt-get install -y nginx

	echo ""
	echo " 5. Installing PHP 7.0 FPM and other PHP 7.0 components..."
	echo ""
	
	apt-get install -y php7.0-fpm php7.0-*
	
	echo ""
	read -p " Would you like install phpMyAdmin ? [y/N] " INSTALL_PHPMYADMIN
	echo ""
	
	if [ "$INSTALL_PHPMYADMIN" = "y" ] ; then
		echo " 6. Installing phpMyAdmin..."
		echo ""

		apt-get install -y phpmyadmin
	fi
	
	read -p " Would you like git clone Let's Encrypt from GitHub ? [y/N] " GITCLONE_LETSENCRYPT
	echo ""
	
	if [ "$GITCLONE_LETSENCRYPT" = "y" ] ; then
		echo " 7. Git cloning Let's Encrypt from GitHub..."
		echo ""
	
		cd /opt/
		
		git clone https://github.com/letsencrypt/letsencrypt
	fi
	
	echo ""
	echo " 8. Configuring Nginx..."
	echo ""

	cd /etc/nginx/

	mv nginx.conf nginx.conf.default

	wget --quiet https://raw.githubusercontent.com/Punk--Rock/Configuration-files/master/nginx/nginx.conf
	
	if [ "$INSTALL_PHPMYADMIN" = "y" ] ; then
		echo " 9. Downloading Nginx default server block with phpMyAdmin..."
		echo ""

		cd sites-available/

		wget --quiet https://raw.githubusercontent.com/Punk--Rock/Configuration-files/master/nginx/sites-available/default.conf

		cd ../sites-enabled/

		rm default

		ln -s /etc/nginx/sites-available/default.conf
	else	
		cd sites-available/
		
		cp default default.conf
		
		cd ../sites-enabled/
		
		rm default
		
		ln -s /etc/nginx/sites-available/default.conf
	fi
	
	echo " 10. Configuring PHP 7.0 FPM..."
	echo ""

	cd /etc/php/7.0/fpm/pool.d/

	mv www.conf www.conf.default

	wget --quiet https://raw.githubusercontent.com/Punk--Rock/Configuration-files/master/php/7.0/fpm/pool.d/www.conf
	
	echo " 11. Restarting Nginx and PHP 7.0 FPM..."
	echo ""

	service nginx restart && service php7.0-fpm restart
	
	echo " That's okay !"
	echo ""
else
	echo ""
	echo "You are not root :("
	echo ""
fi
