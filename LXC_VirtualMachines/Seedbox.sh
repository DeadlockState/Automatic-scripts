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
	
	apt-get install -y curl git-core unzip moreutils
	
	echo ""
	echo " 3. Installing Plex Media Server..."
	echo ""

	cd /tmp/
 
	wget https://downloads.plex.tv/plex-media-server/1.3.4.3285-b46e0ea/plexmediaserver_1.3.4.3285-b46e0ea_amd64.deb
	
	dpkg -i plexmediaserver_1.3.4.3285-b46e0ea_amd64.deb
	
	apt-get update -y
	
	apt-get install plexmediaserver
	
	echo ""
	echo " 4. Installing SickRage..."
	echo ""

	apt-get install -y unrar-free openssl libssl-dev python2.7
	
	sudo addgroup --system sickrage
	
	sudo adduser --disabled-password --system --home /var/lib/sickrage --gecos "SickRage" --ingroup sickrage sickrage
	
	mkdir /opt/sickrage && chown sickrage:sickrage /opt/sickrage
	
	git clone https://github.com/SickRage/SickRage.git /opt/sickrage
	
	cp /opt/sickrage/runscripts/init.ubuntu /etc/init.d/sickrage
	
	chown root:root /etc/init.d/sickrage
	
	chmod 644 /etc/init.d/sickrage
	
	chmod +x /etc/init.d/sickrage
	
	update-rc.d sickrage defaults
	 
	service sickrage start

	echo ""
	echo " 5. Installing CouchPotato..."
	echo ""
	
	apt-get install -y python-pip
	
	echo "Running pip install --upgrade pyopenssl ..."
	
	pip install --upgrade pyopenssl > /dev/null 2>&1
	
	pip install --upgrade pip
	
	cd /opt/
 
	git clone https://github.com/CouchPotato/CouchPotatoServer.git
	
	echo ""
	echo " 6. Configuring CouchPotato..."
	echo ""
 
	cp CouchPotatoServer/init/ubuntu /etc/init.d/couchpotato
 
	cp CouchPotatoServer/init/ubuntu.default /etc/default/couchpotato
	
	sed -i 's/CP_USER=couchpotato/CP_USER=root/g' /etc/default/couchpotato
	
	sed -i 's/CP_HOME=/CP_HOME=\/opt\/CouchPotatoServer/g' /etc/default/couchpotato
	
	chmod +x /etc/init.d/couchpotato
	
	update-rc.d couchpotato defaults
	
	service couchpotato start
	
	cd CouchPotatoServer/couchpotato/core/helpers/
	
	wget --quiet https://raw.githubusercontent.com/Snipees/couchpotato.providers.french/master/namer_check.py
	
	cd /var/opt/couchpotato/
	
	mkdir custom_plugins/ && cd custom_plugins/
	
	mkdir cpasbien t411 torrent9 && cd cpasbien/
	
	wget --quiet https://raw.githubusercontent.com/Snipees/couchpotato.providers.french/master/cpasbien/__init__.py
	
	wget --quiet https://raw.githubusercontent.com/Snipees/couchpotato.providers.french/master/cpasbien/main.py
	
	cd ../t411/
	
	wget --quiet https://raw.githubusercontent.com/Punk--Rock/couchpotato.providers.french/master/t411/__init__.py
	
	wget --quiet https://raw.githubusercontent.com/Punk--Rock/couchpotato.providers.french/master/t411/main.py
	
	cd ../torrent9/
	
	wget --quiet https://raw.githubusercontent.com/Punk--Rock/couchpotato.providers.french/master/torrent9/__init__.py
	
	wget --quiet https://raw.githubusercontent.com/Punk--Rock/couchpotato.providers.french/master/torrent9/main.py
	
	service couchpotato restart
	
	read -p " Would you like install rTorrent + ruTorrent or Transmission ? [r/T] " INSTALL_TORRENT
	echo ""
	
	if [ "$INSTALL_TORRENT" = "r" ] ; then
		echo " 7. Installing rTorrent/ruTorrent (with Nginx)..."
		echo ""

		apt-get install -y automake libcppunit-dev libtool build-essential pkg-config libssl-dev libcurl4-openssl-dev libsigc++-2.0-dev libncurses5-dev screen subversion nginx apache2-utils php7.0 php7.0-fpm php7.0-cli php7.0-curl php-geoip php7.0-xmlrpc unrar rar zip ffmpeg buildtorrent mediainfo python-libtorrent rtorrent
 
		cd /var/www/html/
		 
		git clone https://github.com/Novik/ruTorrent.git rutorrent
		 
		cd rutorrent/plugins/
		 
		git clone https://github.com/xombiemp/rutorrentMobile.git mobile
		
		echo ""
		echo " 8. Configuring ruTorrent"
		echo ""
		
		sed -i 's/$useExternal = false/$useExternal = '\''buildtorrent'\''/g' /var/www/html/rutorrent/plugins/create/conf.php
		
		sed -i 's/$pathToCreatetorrent = '\'''\''/$pathToCreatetorrent = '\''\/usr\/bin\/buildtorrent'\''/g' /var/www/html/rutorrent/plugins/create/conf.php
		
		echo " 9. Configuring Nginx and downloading server block for ruTorrent..."
		echo ""
		
		cd /etc/nginx/

		mv nginx.conf nginx.conf.default

		wget --quiet https://raw.githubusercontent.com/Punk--Rock/Configuration-files/master/nginx/nginx.conf
		
		cd sites-available/

		wget --quiet https://raw.githubusercontent.com/Punk--Rock/Configuration-files/master/nginx/sites-available/rutorrent.conf

		cd ../sites-enabled/

		rm default

		ln -s /etc/nginx/sites-available/rutorrent.conf
		
		sed -i 's/;date.timezone =/date.timezone = Europe\/Paris/g' /etc/php/7.0/fpm/php.ini
		
		read -p " What will be the username to access to ruTorrent ? [rutorrent] " RUTORRENT_USER_TEMP
		echo ""
		
		if [ -z $RUTORRENT_USER_TEMP ] ; then
			RUTORRENT_USER="rutorrent"
		else
			RUTORRENT_USER=$(echo "$RUTORRENT_USER_TEMP" | tr -s '[:upper:]' '[:lower:]')
		fi
		
		read -p " and the password ? [rutorrent] " RUTORRENT_PASSWORD
		
		if [ -z $RUTORRENT_PASSWORD ] ; then
			RUTORRENT_PASSWORD = "rutorrent"
		fi
		
		sed -i 's/rutorrent_user/'$RUTORRENT_USER'/g' /etc/nginx/sites-available/rutorrent.conf
		
		htpasswd -b -c /var/www/html/rutorrent/.htpasswd $RUTORRENT_USER $RUTORRENT_PASSWORD
		
		chmod 400 /var/www/html/rutorrent/.htpasswd
		
		chown www-data:www-data /var/www/html/rutorrent/.htpasswd
		
		service nginx restart && service php7.0-fpm restart
		
		echo ""
		echo " 9. Configuring "$RUTORRENT_USER" user for rTorrent and ruTorrent..."
		echo ""
		
		useradd $RUTORRENT_USER
		
		cd /home/
		
		mkdir $RUTORRENT_USER/ && cd $RUTORRENT_USER/
		
		mkdir torrents watch .session
		
		touch .rtorrent.rc
		
		echo "scgi_port = 127.0.0.1:5001
encoding_list = UTF-8
port_range = 45000-65000
port_random = no
check_hash = no
directory = /home/"$RUTORRENT_USER"/torrents
session = /home/"$RUTORRENT_USER"/.session
encryption = allow_incoming, try_outgoing, enable_retry
schedule = watch_directory,1,1,\"load_start=/home/"$RUTORRENT_USER"/watch/*.torrent\"
schedule = untied_directory,5,5,\"stop_untied=/home/"$RUTORRENT_USER"/watch/*.torrent\"
use_udp_trackers = yes
dht = off
peer_exchange = no
min_peers = 40
max_peers = 100
min_peers_seed = 10
max_peers_seed = 50
max_uploads = 15
execute = {sh,-c,/usr/bin/php /var/www/html/rutorrent/php/initplugins.php "$RUTORRENT_USER" &}
schedule = espace_disque_insuffisant,1,30,close_low_diskspace=500M" > .rtorrent.rc

		chown -R $RUTORRENT_USER:$RUTORRENT_USER /home/$RUTORRENT_USER/
		
		chown root:root /home/$RUTORRENT_USER/
		
		chmod 755 /home/$RUTORRENT_USER/
		
		cd /var/www/html/rutorrent/conf/users/
		
		mkdir $RUTORRENT_USER/ && cd $RUTORRENT_USER/
		
		touch config.php
		
		echo "<?php
\$pathToExternals['curl'] = '/usr/bin/curl';
\$topDirectory = '/home/"$RUTORRENT_USER"';
\$scgi_port = 5001;
\$scgi_host = '127.0.0.1';
\$XMLRPCMountPoint = '/"$RUTORRENT_USER"';" > config.php
	
		chown -R www-data:www-data /var/www/html/
		
		service nginx restart
		
		echo ""
		echo " 10. Configuring rTorrent service..."
		echo ""
		
		cd /etc/init.d/
		
		touch rtorrent
		
		echo "#!/usr/bin/env bash

### BEGIN INIT INFO
# Provides: rtorrent
# Required-Start: \$syslog $network
# Required-Stop: \$syslog $network
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start daemon at boot time
# Description: Start-Stop rtorrent user session
### END INIT INFO

user=\""$RUTORRENT_USER"\"

rt_start() {
	su --command=\"screen -dmS \${user} rtorrent\" \"\${user}\"
}

rt_stop() {
	killall --user \"\${user}\" screen
}

case \"\$1\" in
	start) echo \"Starting rRorrent...\"; rt_start
	;;
	stop) echo \"Stopping rTorrent...\"; rt_stop
	;;
	restart) echo \"Restarting rTorrent...\"; rt_stop; sleep 1; rt_start
	;;
	*) echo \"Usage: \$0 {start|stop|restart}\"; exit 1
	;;

esac
exit 0" > rtorrent
		
		chmod +x rtorrent
		
		update-rc.d rtorrent defaults
		
		service rtorrent start
	else
		echo " 7. Installing Transmission..."
		echo ""
		
		apt-get install -y transmission-daemon
		
		echo ""
		echo " 8. Configuring Transmission..."
		echo ""
		
		sed -i 's/rpc-whitelist-enabled\": true/rpc-whitelist-enabled\": false/g' /etc/transmission-daemon/settings.json
		
		service transmission-daemon reload
		
		cd /usr/share/transmission/web/
		
		mv index.html index.orignal.html
		
		cd ../
		
		wget https://github.com/ronggang/transmission-web-control/raw/master/release/transmission-control-full.tar.gz
		
		tar -zxf transmission-control-full.tar.gz
		
		service transmission-daemon reload
	fi
	
	IP_ADDRESS=`ifdata -pa eth0`
	
	echo ""
	echo " That's okay !"
	echo ""
	echo " Plex : http://"$IP_ADDRESS":32400/web/"
	echo " SickRage : http://"$IP_ADDRESS":8081/home/"
	echo " CouchPotato : http://"$IP_ADDRESS":5050"
	if [ "$INSTALL_TORRENT" = "r" ] ; then
		echo " ruTorrent : http://"$IP_ADDRESS"   (username : "$RUTORRENT_USER" / password : "$RUTORRENT_PASSWORD")"
	else
		echo " Transmission : http://"$IP_ADDRESS":9091   (username/password : transmission)"
	fi
	echo ""
else
	echo ""
	echo "You are not root :("
	echo ""
fi
