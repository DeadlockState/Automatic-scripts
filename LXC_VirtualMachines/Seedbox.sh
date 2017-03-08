#!/bin/sh
if [ "$USER" = "root" ] ; then
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
	
	cp -v /opt/sickrage/runscripts/init.ubuntu /etc/init.d/sickrage
	
	chown root:root /etc/init.d/sickrage
	
	chmod 644 /etc/init.d/sickrage
	
	chmod +x /etc/init.d/sickrage
	
	update-rc.d sickrage defaults
	 
	service sickrage start

	echo ""
	echo " 5. Installing CouchPotato..."
	echo ""
	
	apt-get install -y python-pip
	
	echo "pip install --upgrade pyopenssl is running..."
	
	pip install --upgrade pyopenssl > /dev/null 2>&1
	
	pip install --upgrade pip
	
	cd /opt/
 
	git clone https://github.com/CouchPotato/CouchPotatoServer.git
	
	echo ""
	echo " 6. Configuring CouchPotato..."
	echo ""
 
	cp CouchPotatoServer/init/ubuntu /etc/init.d/couchpotato
 
	cp CouchPotatoServer/init/ubuntu.default /etc/default/couchpotato
	
	sed -i 's/CP_USER=couchpotato/CP_USER=root/g' /etc/transmission-daemon/settings.json
	
	sed -i 's/CP_HOME=/CP_HOME=\/opt\/CouchPotatoServer/g' /etc/transmission-daemon/settings.json
	
	chmod +x /etc/init.d/couchpotato
	
	update-rc.d couchpotato defaults
	
	service couchpotato start
	
	echo ""
	read -p " Would you like install rTorrent + ruTorrent or Transmission ? [r/T] " INSTALL_TORRENT
	echo ""
	
	if [ "$INSTALL_TORRENT" = "r" ] ; then
		echo " 7. Installing rTorrent + ruTorrent..."
		echo ""

		# 
	else
		echo " 7. Installing Transmission..."
		echo ""
		
		apt-get install -y transmission-daemon
		
		echo ""
		echo " 8. Configuring Transmission..."
		echo ""
		
		sed -i 's/rpc-whitelist-enabled\": true,/rpc-whitelist-enabled\": false,/g' /etc/transmission-daemon/settings.json
		
		service transmission-daemon reload
		
		cd /usr/share/transmission/web/
		
		mv index.html index.orignal.html
		
		cd ../
		
		wget https://github.com/ronggang/transmission-web-control/raw/master/release/transmission-control-full.tar.gz
		
		tar -zxvf transmission-control-full.tar.gz
		
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
		echo " ruTorrent : http://"$IP_ADDRESS":XXXX"
	else
		echo " Transmission : http://"$IP_ADDRESS":9091 with transmission/transmission credentials"
	fi
else
	echo ""
	echo "You are not root :("
	echo ""
fi
