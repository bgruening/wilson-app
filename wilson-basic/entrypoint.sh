#!/bin/bash -e

# Render shiny-server configuration file template
j2 /srv/shiny-server/shiny-server.conf.j2 > /srv/shiny-server/shiny-server.conf

# Render .Renviron file template
j2 /srv/shiny-server/.Renviron.j2 > /home/shiny/.Renviron

exec "$@"