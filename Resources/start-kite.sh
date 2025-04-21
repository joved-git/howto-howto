#!/bin/sh
# Joved (2025)
#

docker stop Kite
docker start Kite
docker exec -it -u kite Kite /bin/bash
