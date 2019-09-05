#!/bin/bash -e
j2 /srv/shiny-server/shiny-server.conf.j2 > /srv/shiny-server/shiny-server.conf

exec "$@"