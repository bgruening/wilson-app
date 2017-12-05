# WIlsON: Webbased Interactive Omics visualizatioN -  The Application
## Abstract
This repository contains the reference application of the [WIlsON R package]( https://github.molgen.mpg.de/loosolab/wilson), which is intended to provide HT screening results to the end user, either via a centralized R Shiny server, via applications such as Rstudio, or as a virtualized Docker container for offline usage. Please refer to that repository for a more detailed description. The WIlsON tool is a first step towards a user friendly and customizable omics result presentation that enables end users to generate high quality publication ready graphics without any programming skills.

## Example application
WIlsON can be tested on our [official demonstration server](http://loosolab.mpi-bn.mpg.de/apps/wilson/).  

## Docker
Get a Docker container [here](https://hub.docker.com/r/loosolab/wilson/).

## Installation of R Shiny server in “virgin” Debian 9 Linux
Update and install the following Debian packages.
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install r-base libnlopt-dev  wget libssl-dev libxml2-dev libcurl4-openssl-dev git gdebi-core
```

Install **R Shiny server** according to the manual found here https://www.rstudio.com/products/shiny/download-server/ (make sure to install to global R library, NOT personal!).

Start R and install the **WIlsON R package** and dependencies (make sure to install to global R library, NOT personal!).
```
R
install.packages("devtools")
devtools::install_github(repo = "HendrikSchultheis/wilson", ref = "package", host="github.molgen.mpg.de/api/v3", auth_token = "00fd601b5439997d3a637c6fecf6e6a50eaf9d09")
#to be replaced with later:  devtools::install_github(repo = "loosolab/wilson", host="github.molgen.mpg.de/api/v3")
```

Download the **WIlsON R application** archive from https://github.molgen.mpg.de/loosolab/wilson-apps/tree/hendrik-basic and unzip. Move wilson-basic folder into R Shiny server apps folder (e.g. /srv/shiny-server/sample-apps/wilson-basic).

Change the owner of the R Shiny apps folder to be the “shiny” user.
```
sudo chown –R shiny:shiny /srv/shiny-server/sample-apps 
```

Restart R Shiny server.
```
sudo systemctl stop shiny-server
sudo systemctl daemon-reload
sudo systemctl start shiny-server
```

## More
Please make sure to check our other projects at http://loosolab.mpi-bn.mpg.de/.

## License
This project is licensed under the MIT license.
