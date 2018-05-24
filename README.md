# WIlsON: Webbased Interactive Omics visualizatioN -  The Application
## Abstract
This repository contains the reference application of the [WIlsON R package]( https://github.molgen.mpg.de/loosolab/wilson), which is intended to provide HT screening results to the end user, either via a centralized R Shiny server, via applications such as Rstudio, or as a virtualized Docker container for offline usage. Please refer to that repository for a more detailed description. The WIlsON tool is a first step towards a user friendly and customizable omics result presentation that enables end users to generate high quality publication ready graphics without any programming skills.

## Availability
WIlsON can be tested on our [official demonstration server](http://loosolab.mpi-bn.mpg.de/apps/wilson/). 

Get a Docker container [here](https://hub.docker.com/r/loosolab/wilson/).

The underlying WIlsON R package can be downloaded [here](https://github.molgen.mpg.de/loosolab/wilson). 

Please make sure to check our other projects at http://loosolab.mpi-bn.mpg.de/.

## Installation of R Shiny server in “virgin” Debian 9 Linux
Update and install the following Debian packages.
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install r-base libnlopt-dev wget libssl-dev libxml2-dev libcurl4-openssl-dev git gdebi-core
```

Install **R Shiny server** according to the manual found here https://www.rstudio.com/products/shiny/download-server/ (make sure to install to global R library, NOT personal!).

Start R and install the **WIlsON R** package and dependencies (make sure to install to global R library, NOT personal!).
```
R
install.packages("devtools")
devtools::install_github(repo = "loosolab/wilson", host="github.molgen.mpg.de/api/v3")
```

Download the **WIlsON R application** archive from https://github.molgen.mpg.de/loosolab/wilson-apps and unzip. Move wilson-basic folder into R Shiny server apps folder (e.g. /srv/shiny-server/sample-apps/wilson-basic).

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

## Server structure
The R Shiny WIlsON application consists of the following components.
```
app.R		-> R code
/data		-> Folder with input file(s) (CLARION format)
/introduction	-> Introduction / Data Format web pages
/www		-> WIlsON logo
```

## CLARION input format

CLARION: generiC fiLe formAt foR quantItative cOmparsions of high throughput screeNs

CLARION is a data format especially developed to be used with WIlsON, which relies on a tab-delimited table with a metadata header to describe the following columns. It is based on the Summarized Experiment format and supports all types of data which can be reduced to features and their annotation (e.g. genes, transcripts, proteins, probes) with assigned numerical values (e.g. count, score, log2foldchange, z-score, p-value). Most result tables derived from RNA-Seq, ChIP/ATAC-Seq, Proteomics, Microarrays, and many other analyses can thus be easily reformatted to become compatible without having to modify the code of WIlsON for each specific experiment.

Please check the following link for details considering the [CLARION format](https://github.molgen.mpg.de/loosolab/wilson-apps/wiki/CLARION-Format).

## How do I load my own data?
Add the file suffix *.clarion* or *.se*, and place it/them into the /data folder. Then you reload the app or the R Shiny server. That’s it! 
```
cp mydata.clarion /srv/shiny-server/sample-apps/data
sudo systemctl stop shiny-server
sudo systemctl daemon-reload
sudo systemctl start shiny-server
```

## Run app in RStudio
To run this app in your local RStudio you have to install the **WIlsON R package** and it's dependencies.
```
install.packages("devtools")
devtools::install_github(repo = "loosolab/wilson", host="github.molgen.mpg.de/api/v3")
```
Now either clone the repository and use ``runApp()``:
```
# Switch with setwd into the main folder e.g. wilson-apps.
setwd('yourPath'/wilson-apps)
# Use runApp to run the desired app. E.g. for wilson-basic
shiny::runApp("wilson-basic/")
```
Or use ``runUrl()``:
```
shiny::runUrl("https://github.molgen.mpg.de/loosolab/wilson-apps/archive/master.zip", subdir = "/wilson-basic")
```

## How to cite
* Schultheis H, Kuenne C, Preussner J, Wiegandt R, Fust A, Bentsen M, Looso M. WIlsON: Webbased Interactive Omics VisualizatioN. (2018), doi: https://XY

## License
This project is licensed under the MIT license.
