# Automatic scripts

## LXC

### LAMP.sh

Preparing and installing a fully LAMP server (Apache 2.4 + PHP 7.0 + MySQL + phpMyAdmin (optional) + Let's Encrypt(optional)) on a LXC

```shell
  #!/bin/bash
  wget --no-cache https://raw.githubusercontent.com/Punk--Rock/Automatic-scripts/master/LXC/LEMP.sh

  chmod +x LEMP.sh
  
  set -o nounset
    
    command1_dfh() { # volume
      volume=$1
      df -h | grep $1
    }
```

### LEMP.sh

Preparing and installing a fully LEMP server (Nginx + PHP 7.0 FPM + MySQL + phpMyAdmin (optional) + Let's Encrypt (optional)) on a LXC

## Virtual machines
