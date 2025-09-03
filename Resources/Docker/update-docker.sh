#!/bin/sh
# Joved (2025)
#

# Remove last version (container and image)
docker stop Kite
docker rm Kite
docker image rm joved/kite

# Update Kite
if [ `ls | grep howto-howto | wc -l` = 0 ];
then
    git clone https://github.com/joved-git/howto-howto.git tmp
else
    cd tmp
    git pull
    cd ..
fi

# Create image and container
docker build -t joved/kite .
docker run -it -u kite --name Kite joved/kite /bin/bash

# Remove temprary files
rm -fr tmp
