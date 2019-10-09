FROM rocker/shiny:3.6.1
LABEL maintainer="Jens Preussner <jens.preussner@mpi-bn.mpg.de>"
LABEL maintainer="Hendrik Schultheis <hendrik.schultheis@mpi-bn.mpg.de>"
LABEL maintainer="Carsten Kuenne <carsten.kuenne@mpi-bn.mpg.de>"
LABEL version="2.1.0"

#
# Configuration
#
ENV \
    # Define the default location from which the app is served
    WILSON_LOCATION=/ \
    # Define the landing page for the app
    WILSON_LANDING_PAGE=introduction

#
# Move app and data to container
#
COPY . /srv/shiny-server

#
# Installation procedure
#
RUN apt-get update && apt-get install -y \
    libnlopt-dev \
    libssl-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    git \
    procps \
    python-pip && \
    apt-get clean && \
    # Install jinja2 templating engine
    pip install j2cli && \
    # Install R infrastructure
    R -e "install.packages(c('BiocManager', 'webshot'), repos = c(CRAN = 'https://cloud.r-project.org/'))" && \
    R -e "webshot::install_phantomjs()" && \
    R -e "BiocManager::install(c('shinyBS', 'shinydashboard', 'shinythemes', 'htmltools', 'wilson'))" && \
    cp /root/bin/phantomjs /usr/local/bin && \
    # Move entrypoint, create log directory
    mv /srv/shiny-server/entrypoint.sh / && \
    mkdir /srv/shiny-server/logs && \
    # Change ownerships
    chmod -R ugo+wrX /var/log/shiny-server/ && \
    chown -R shiny:shiny /srv/shiny-server/ && \
    # Clean up existing sample apps
    rm -rf /srv/shiny-server/[0-9][0-9]_* /srv/shiny-server/index.html /srv/shiny-server/sample-apps

# Start container
USER shiny
CMD ["/entrypoint.sh", "/usr/bin/shiny-server.sh"]
