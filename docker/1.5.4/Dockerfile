# Pulls debian:latest from dockerhub
FROM debian

# Dockerfile questions go to
MAINTAINER C. Kuenne / MPI-BN / Bioinformatics / carsten.kuenne@mpi-bn.mpg.de

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
RUN Rscript -e "install.packages(c('devtools'), repos='https://cran.rstudio.com/')"

#Installs BIOCONDUCTOR/BiocInstaller
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R")'

#Install Shiny-Server
#RUN wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.6.875-amd64.deb && \
#gdebi -n shiny-server-1.5.6.875-amd64.deb && \
#RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.7.907-amd64.deb && \
#gdebi -n shiny-server-1.5.7.907-amd64.deb && \
RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb && \
gdebi -n shiny-server-1.5.9.923-amd64.deb && \
rm /srv/shiny-server/index.html && \
rm -rf /srv/shiny-server/sample-apps

#install shinythemes
RUN Rscript -e 'install.packages("shinythemes", repos="http://cran.wustl.edu/")'

#install shinyBS
RUN Rscript -e 'install.packages("shinyBS", repos="http://cran.wustl.edu/")'

#install old mvtnorm package (1.0-8), because the current 1.0-10 needs r 3.5 (current debian r is 3.3)
RUN Rscript -e 'devtools::install_version(repos="http://cran.wustl.edu/", package = "mvtnorm", version = "1.0-8")'

#Install WILSON
RUN Rscript -e 'devtools::install_github(repo = "loosolab/wilson", host="github.molgen.mpg.de/api/v3", auth_token = NULL, upgrade = "never")'

#Install stackdump
#RUN Rscript -e 'devtools::install_github(repo = "jcheng5/stackdump")'

#Install WILSON App
#RUN git clone -b stackdump https://github.molgen.mpg.de/loosolab/wilson-apps /srv/shiny-server/tmp && \
RUN git clone https://github.molgen.mpg.de/loosolab/wilson-apps /srv/shiny-server/tmp && \
cp -a /srv/shiny-server/tmp/wilson-basic/. /srv/shiny-server/ && \
rm -rf /srv/shiny-server/tmp

#Install webshot/phantomjs to permit download of interactive plots with plot.ly
RUN Rscript -e 'install.packages("webshot", repos="http://cran.wustl.edu")'
RUN Rscript -e 'webshot::install_phantomjs()'
RUN cp /root/bin/phantomjs /usr/local/bin

EXPOSE 3838

RUN rm -rf /srv/shiny-server/data && \
mkdir /srv/shiny-server/data

#check current directory for the presence of clarion input files (*.se, *.clarion) -> include in container
#add pointless additional copy of entrypoint.sh because otherwise the building will fail if no clarion files exist (yuck!)
ADD entrypoint.sh *.se *.clarion /srv/shiny-server/data/
RUN rm /srv/shiny-server/data/entrypoint.sh

ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

#switch shiny user uid to 1000 (previously docker user); set permissions
RUN usermod -u 1000 shiny && \
chown -R shiny:shiny /srv/shiny-server/ && \
mkdir -p /srv/shiny-server/logs && \
chmod ugo+wrX /srv/shiny-server/logs

CMD ["/usr/bin/entrypoint.sh"]
