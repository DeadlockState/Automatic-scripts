locale-gen en_US en_US.UTF-8

apt-get update && apt-get upgrade

apt-get dist-upgrade

apt-get install mysql-server mysql-client

apt-get install nginx

apt-get install php7.0-fpm php7.0-*

apt-get install phpmyadmin

apt-get install git-core
 
cd /opt/
 
git clone https://github.com/letsencrypt/letsencrypt

cd /etc/nginx/

mv nginx.conf nginx.conf.original

wget https://raw.githubusercontent.com/Punk--Rock/Configuration-files/master/nginx/nginx.conf

cd conf.d/

wget https://raw.githubusercontent.com/Punk--Rock/Configuration-files/master/nginx/conf.d/proxy.conf

cd /etc/php/7.0/fpm/pool.d/

mv www.conf www.conf.original

wget https://raw.githubusercontent.com/Punk--Rock/Configuration-files/master/php/7.0/fpm/pool.d/www.conf

service nginx restart && service php7.0-fpm restart
