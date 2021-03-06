# Punk--Rock's Automatic scripts


![Utilities](https://cdn2.iconfinder.com/data/icons/oxygen/48x48/categories/preferences-system.png)

## Utilities

#### VirtualHost creator ([VirtualHost_creator.sh](https://github.com/Punk--Rock/Automatic-scripts/blob/master/utilities/VirtualHost_creator.sh))

Creates automatically a new VirtualHost (SSL or not) on your Apache or Nginx web server, you just need to fill the FQDN and the webmaster's email address of the server

```shell
wget https://raw.githubusercontent.com/Punk--Rock/Automatic-scripts/master/utilities/VirtualHost_creator.sh

chmod +x VirtualHost_creator.sh
```

#### Let's Encrypt Updater ([LetsEncrypt_updater.sh](https://github.com/Punk--Rock/LetsEncrypt-Tools/blob/master/letsencrypt_updater.sh))

Automatically updates Let's Encrypt with a fresh git-clone

See [installation](https://github.com/Punk--Rock/LetsEncrypt-Tools#installation)

#### Let's Encrypt auto renew ([LetsEncrypt_autorenew.sh](https://github.com/Punk--Rock/LetsEncrypt-Tools/blob/master/letsencrypt_autorenew.sh))

This script check days remaining before the expiration of your SSL certificates and renew automatically certificates that expires in less than 20 days

See [installation](https://github.com/Punk--Rock/LetsEncrypt-Tools#installation-1)
<br><br><br>
![Container](https://cdn2.iconfinder.com/data/icons/iconslandgps/PNG/48x48/Containers/ContainerRed.png)

## For LXC containers and Virtual Machines

#### LAMP ([LAMP.sh](https://github.com/Punk--Rock/Automatic-scripts/blob/master/LXC_VirtualMachines/LAMP.sh))

Preparing and installing a fully LAMP server (Apache 2.4 + PHP 7.0 + MySQL + phpMyAdmin (optional) + Let's Encrypt(optional))

```shell
wget https://raw.githubusercontent.com/Punk--Rock/Automatic-scripts/master/LXC_VirtualMachines/LAMP.sh

chmod +x LAMP.sh
```

#### LEMP ([LEMP.sh](https://github.com/Punk--Rock/Automatic-scripts/blob/master/LXC_VirtualMachines/LEMP.sh))

Preparing and installing a fully LEMP server (Nginx + PHP 7.0 FPM + MySQL + phpMyAdmin (optional) + Let's Encrypt (optional))

```shell
wget https://raw.githubusercontent.com/Punk--Rock/Automatic-scripts/master/LXC_VirtualMachines/LEMP.sh

chmod +x LEMP.sh
```

#### Seedbox ([Seedbox.sh](https://github.com/Punk--Rock/Seedbox-installer/blob/master/Seedbox.sh))

Preparing and installing a fully seedbox server (Plex Media Server + Sonarr/Radarr or SickRage/CouchPotato + Transmission or rTorrent/ruTorrent + Jackett + PlexPy)

See [installation](https://github.com/Punk--Rock/Seedbox-installer#installation)

## Contact me

[![Twitter](https://cdn1.iconfinder.com/data/icons/logotypes/32/twitter-24.png)](https://twitter.com/Punk__R0ck) [@Punk__R0ck](https://twitter.com/Punk__R0ck)
