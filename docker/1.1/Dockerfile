# Pulls debian:latest from dockerhub
FROM debian
  
# Dockerfile questions go to
MAINTAINER P. Hofmann / MPI-BN / IT Service Group / peter.hofmann@mpi-bn.mpg.de
  
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
gdebi-core && \
apt-get clean && \
 
#Installs DEVTOOLS
Rscript -e "install.packages(c('devtools'), \
repos='https://cran.rstudio.com/')" && \
 
#Installs BIOCONDUCTOR/BiocInstaller
Rscript -e 'source("https://bioconductor.org/biocLite.R")' && \
 
#Install Shiny-Server
wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.6.875-amd64.deb && \
gdebi -n shiny-server-1.5.6.875-amd64.deb && \
rm /srv/shiny-server/index.html && \
rm -rf /srv/shiny-server/sample-apps && \
  
#Install WILSON
Rscript -e 'devtools::install_github(repo = "loosolab/wilson", host="github.molgen.mpg.de/api/v3")' && \
  
#Install WILSON App
git clone https://github.molgen.mpg.de/loosolab/wilson-apps /srv/shiny-server/tmp && \
cp -a /srv/shiny-server/tmp/wilson-basic/. /srv/shiny-server/ && \
rm -rf /srv/shiny-server/tmp && \
rm -rf /srv/shiny-server/data && \
mkdir /srv/shiny-server/data && \
chown -R shiny:shiny /srv/shiny-server/
  
EXPOSE 3838
  
CMD ["shiny-server"]
