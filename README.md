[Terminal](http://image.noelshack.com/fichiers/2017/10/1489018271-472772-appicns-terminal.png)

# Punk--Rock's automatic scripts

[Utilities](https://cdn2.iconfinder.com/data/icons/oxygen/64x64/categories/preferences-system.png)

## Utilities

#### VirtualHost creator ([VirtualHost_creator.sh](https://github.com/Punk--Rock/Automatic-scripts/blob/master/utilities/VirtualHost_creator.sh))

Creates automatically a new VirtualHost (SSL or not) on your Apache or Nginx web server, you just need to fill the FQDN and the webmaster's email address of the server

```shell
wget --no-cache https://raw.githubusercontent.com/Punk--Rock/Automatic-scripts/master/utilities/VirtualHost_creator.sh

chmod +x VirtualHost_creator.sh
```

[Container](https://cdn2.iconfinder.com/data/icons/iconslandgps/PNG/64x64/Containers/ContainerRed.png)

## For LXC containers and Virtual Machines

#### LAMP ([LAMP.sh](https://github.com/Punk--Rock/Automatic-scripts/blob/master/LXC_VirtualMachines/LAMP.sh))

Preparing and installing a fully LAMP server (Apache 2.4 + PHP 7.0 + MySQL + phpMyAdmin (optional) + Let's Encrypt(optional))

```shell
wget --no-cache https://raw.githubusercontent.com/Punk--Rock/Automatic-scripts/master/LXC_VirtualMachines/LAMP.sh

chmod +x LAMP.sh
```

#### LEMP ([LEMP.sh](https://github.com/Punk--Rock/Automatic-scripts/blob/master/LXC_VirtualMachines/LEMP.sh))

Preparing and installing a fully LEMP server (Nginx + PHP 7.0 FPM + MySQL + phpMyAdmin (optional) + Let's Encrypt (optional))

```shell
wget --no-cache https://raw.githubusercontent.com/Punk--Rock/Automatic-scripts/master/LXC_VirtualMachines/LEMP.sh

chmod +x LEMP.sh
```

#### Seedbox ([Seedbox.sh](https://github.com/Punk--Rock/Automatic-scripts/blob/master/LXC_VirtualMachines/Seedbox.sh))

Preparing and installing a fully seedbox server (Plex + SickRage + CouchPotato + rTorrent/ruTorrent or Transmission)

```shell
wget --no-cache https://raw.githubusercontent.com/Punk--Rock/Automatic-scripts/master/LXC_VirtualMachines/Seedbox.sh

chmod +x Seedbox.sh
```
