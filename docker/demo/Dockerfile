# Pulls debian:latest from dockerhub
FROM debian

# Dockerfile questions go to
MAINTAINER C. Kuenne / MPI-BN / Bioinformatics Core Unit / carsten.kuenne@mpi-bn.mpg.de

#Some basic packages, updates and cleanup
RUN apt-get -y update && apt-get -y upgrade && \
apt-get -y install \
r-base \
wget \
libnlopt-dev \
libssl-dev \
libxml2-dev \
libcurl4-openssl-dev \
git \
procps \
gdebi-core && \
apt-get clean

#Installs DEVTOOLS
RUN Rscript -e "install.packages(c('devtools'), \
repos='https://cran.rstudio.com/')"

#Installs BIOCONDUCTOR/BiocInstaller
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R")'

#Install Shiny-Server
#RUN wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.6.875-amd64.deb && \
#gdebi -n shiny-server-1.5.6.875-amd64.deb && \
RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.7.907-amd64.deb && \
gdebi -n shiny-server-1.5.7.907-amd64.deb && \
rm /srv/shiny-server/index.html && \
rm -rf /srv/shiny-server/sample-apps

#Install WILSON
RUN Rscript -e 'devtools::install_github(repo = "loosolab/wilson", host="github.molgen.mpg.de/api/v3")'

#Install stackdump
#RUN Rscript -e 'devtools::install_github(repo = "jcheng5/stackdump")'

#Install WILSON App
#RUN git clone -b stackdump https://github.molgen.mpg.de/loosolab/wilson-apps /srv/shiny-server/tmp && \
RUN git clone https://github.molgen.mpg.de/loosolab/wilson-apps /srv/shiny-server/tmp && \
cp -a /srv/shiny-server/tmp/wilson-basic/. /srv/shiny-server/ && \
rm -rf /srv/shiny-server/tmp


EXPOSE 3838

#check current directory for the presence of clarion input files (*.se, *.clarion) -> include in container
#add pointless additional copy of entrypoint.sh because otherwise the building will fail if no clarion files exist
ADD entrypoint.sh *.se *.clarion /srv/shiny-server/data
RUN rm /srv/shiny-server/data/entrypoint.sh

ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

#switch shiny user uid to 1000 (previously docker user); set permissions
RUN usermod -u 1000 shiny && \
chown -R shiny:shiny /srv/shiny-server/ && \
mkdir -p /srv/shiny-server/logs && \
chmod ugo+wrX /srv/shiny-server/logs

CMD ["/usr/bin/entrypoint.sh"]
