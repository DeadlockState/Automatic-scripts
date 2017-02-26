#!/bin/sh
echo ""
read -p "What's the FQDN of your VirtualHost ? [example.domain.com] " FQDN
echo ""
read -p "What's the webmaster's email address ? [webmaster@localhost] " EMAIL
echo ""
read -p "Do you want enable SSL ? [y/N] " SSL

cd /etc/

if [ -f "/etc/apache2/apache2.conf" ] ; then
	cd /var/www/html/

	mkdir $FQDN

	cd /etc/apache2/sites-available/

	touch $FQDN.conf

	if [ $SSL = "y" ] ; then
		echo "# "$FQDN".conf

<VirtualHost *:80>
	Redirect permanent / https://"$FQDN"/
</VirtualHost>

<VirtualHost *:443>
	ServerAdmin "$EMAIL"

	DocumentRoot /var/www/html
	
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	ServerSignature Off
	
	# SSL
	SSLEngine On
	
	SSLCertificateFile /etc/letsencrypt/live/"$FQDN"/fullchain.pem
	SSLCertificateKeyFile /etc/letsencrypt/live/"$FQDN"/privkey.pem

	SSLProtocol -All +TLSv1.2

	SSLCompression Off

	# Diffie-Hellman
	SSLOpenSSLConfCmd Curves secp384r1	

	# Ciphers
	SSLHonorCipherOrder On
	SSLCipherSuite EECDH+AESGCM:EECDH+AES
	# SSLCipherSuite ECDHE-RSA-AES256-GCM-SHA384
	
	# OSCP Stapling
	# SSLUseStapling On
	SSLStaplingResponderTimeout 5
	SSLStaplingReturnResponderErrors Off
	SSLCACertificateFile /etc/letsencrypt/live/"$FQDN"/chain.pem
	
	# TLS parameters

	# HSTS
	Header always set Strict-Transport-Security \"max-age=15768000; includeSubDomains; preload\"
	Header always set X-Content-Type-Options \"nosniff\"
	Header always set X-Frame-Options \"SAMEORIGIN\"
	Header always set X-Xss-Protection \"1; mode=block\"
	Header always set X-Robots-Tag \"none\"
	Header always set X-Download-Options \"noopen\"
	Header always set Content-Security-Policy \"none\"
		
	<FilesMatch \"\.(cgi|shtml|phtml|php)$\">
		SSLOptions +StdEnvVars
	</FilesMatch>
	<Directory /usr/lib/cgi-bin>
		SSLOptions +StdEnvVars
	</Directory>
</VirtualHost>" > $FQDN.conf
	else
		echo "# "$FQDN".conf

<VirtualHost *:80>
	ServerName "$FQDN"

	ServerAdmin "$EMAIL"
	DocumentRoot /var/www/html/"$FQDN"
	
	ServerSignature Off

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > $FQDN.conf
	fi

	cd ../sites-enabled/

	ln -s /etc/apache2/sites-available/$FQDN.conf
	
	echo ""
	echo "Now restart Apache (service apache2 restart) for this new VirtualHost take effect"
	echo ""
	
elif [ -f "nginx.conf" ] ; then
	cd /var/www/html/
		
	mkdir $FQDN
	
	cd /etc/nginx/sites-available/

	touch $FQDN.conf
	
	if [ $SSL = "y" ] ; then
		echo "# "$FQDN".conf

server {
	listen 80;
	server_name "$FQDN";
	return 301 https://$server_name$request_uri;
}

server {
	listen 443 ssl http2;
	listen [::]:443 ssl;

	server_name "$FQDN";
	
	root /var/www/html;
	
	# SSL
	ssl_protocols TLSv1.2;

	ssl_certificate /etc/letsencrypt/live/"$FQDN"/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/"$FQDN"/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/"$FQDN"/chain.pem;

	# Diffie-Hellman
	ssl_ecdh_curve secp384r1;

	# Ciphers
	ssl_ciphers EECDH+AESGCM:EECDH+AES;
	ssl_prefer_server_ciphers on;

	# OCSP Stapling
	resolver 80.67.169.12 80.67.169.40 valid=300s;
	resolver_timeout 5s;
	ssl_stapling on;
	ssl_stapling_verify on;

	# TLS parameters
	ssl_session_cache shared:SSL:10m;
	ssl_session_timeout 5m;
	ssl_session_tickets off;

	# HSTS
	add_header Strict-Transport-Security \"max-age=15768000; includeSubDomains; preload;\";
	add_header X-Content-Type-Options nosniff;
	add_header X-Frame-Options \"SAMEORIGIN\";
	add_header X-XSS-Protection \"1; mode=block\";
	add_header X-Robots-Tag none;
	add_header X-Download-Options noopen;
	add_header X-Permitted-Cross-Domain-Policies none;

	index index.php index.html index.htm index.nginx-debian.html;

	location / {
		try_files $uri $uri/ =404;
	}

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		# With php7.0-cgi alone:
		# fastcgi_pass 127.0.0.1:9000;
		# With php7.0-fpm:
		fastcgi_pass unix:/run/php/php7.0-fpm.sock;
	}

	location ~ /\.ht {
		deny all;
	}
}" > $FQDN.conf
	else
		echo "# "$FQDN".conf

server {
	listen 80 default_server;
	listen [::]:80 default_server;

	server_name "$FQDN";
	
	root /var/www/html;

	index index.php index.html index.htm index.nginx-debian.html;

	location / {
		try_files $uri $uri/ =404;
	}

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		# With php7.0-cgi alone:
		# fastcgi_pass 127.0.0.1:9000;
		# With php7.0-fpm:
		fastcgi_pass unix:/run/php/php7.0-fpm.sock;
	}

	location ~ /\.ht {
		deny all;
	}
}" > $FQDN.conf
		
		cd ../sites-enabled/

		ln -s /etc/nginx/sites-available/$FQDN.conf
	
		echo ""
		echo "Now restart Nginx (service nginx restart) for this new VirtualHost take effect"
		echo ""
	
else
	echo ""
	echo "No web server is installed"
	echo ""
fi
