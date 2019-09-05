# WIlsON: Webbased Interactive Omics visualizatioN -  Applications

## Abstract

This repository contains reference applications that utilize functions from the [WIlsON R package]( https://github.molgen.mpg.de/loosolab/wilson). It is primarily intended to empower high-throughput service platforms to offer access to pre-calculated high-throughput screening results to non-computational scientist. Facilitated by an [open file format](https://github.molgen.mpg.de/loosolab/wilson-apps/wiki/CLARION-Format), WIlsON supports all types of -omics screens, serves results via a web-based dashboard, and enables users to perform analyses and generate publication-ready visualizations without programming skills.

## Application deployment

A WIlsON application typically consists of the following components:

- an `app.R` file, containing all R code of the application.
- a `data` directory, containing input file(s) in CLARION format.
- an `introduction` directory, containing markdown documents of the landing page.
- a `www` directory, containing images and logos.

Applications described here can easily be deployed [locally](#using-rstudio), on a [centralized R Shiny server](#using-a-shiny-server), or anywhere using [Docker containers](#using-docker-containers):

### Using RStudio

1. On Windows-based systems, install [RTools](https://cran.r-project.org/bin/windows/Rtools/).
2. Install all prerequisites using `install.packages("BiocManager", "webshot"); BiocManager::install(c("shinyBS", "shinydashboard", "shinythemes", "htmltools", "wilson"))`.
3. Download the WIlsON applications from the [Releases](https://github.molgen.mpg.de/loosolab/wilson-apps/releases) page and extract them on your local disk.
4. Set the working directory to the extracted release using `setwd("file/to/extracted_release")`.
5. Run an app, e.g. `shiny::runApp("wilson-basic/")`.

### Using a Shiny server

1. Similar to the local usage, install all prerequisites using `install.packages("BiocManager", "webshot"); BiocManager::install(c("shinyBS", "shinydashboard", "shinythemes", "htmltools", "wilson"))`.
2. Download the WIlsON applications from the [Releases](https://github.molgen.mpg.de/loosolab/wilson-apps/releases) page and extract them on the shiny servers disk.
3. Move the application folder(s) into the shiny servers application folder (e.g. to `/srv/shiny-server/wilson-basic`).
4. Restart your shiny server.

### Using Docker Containers

1. Pull one of [WIlsONs application images](#available-images) using e.g. `docker pull loosolab/wilson-basic:2.1.0`.
2. Rund the application image using `docker run -d loosolab/wilson-basic:2.1.0`.

#### Available images

Currently, the following application images are available:

* [WIlsON basic](https://hub.docker.com/r/loosolab/wilson-basic/tags)

## Loading custom data

For deployments using (RStudio)[#using-rstudio] and [Shiny Server](#using-a-shiny-server), it is sufficient to add [CLARION](#clarion) files to the `/data` folder and reload the app/server.
The new dataset can be selected from the within the app, using the drop down menu in the feature selection panel.

For the Docker deployment, mount a directory with the [CLARION](https://github.molgen.mpg.de/loosolab/wilson-apps/wiki/CLARION-Format) files to `srv/shiny-server/external_data/` using Dockers `-v /path/to/files:/srv/shiny-server/external_data`. 

## How to cite
* Schultheis H, Kuenne C, Preussner J, Wiegandt R, Fust A, Bentsen M, Looso M. WIlsON: Webbased Interactive Omics VisualizatioN. (2018), doi: https://doi.org/10.1093/bioinformatics/bty711

## Further information

* WIlsON can be tested on our [official demonstration server](http://loosolab.mpi-bn.mpg.de/apps/wilson/). 
* The underlying WIlsON R package can be installed from [CRAN](https://cran.r-project.org/web/packages/wilson/index.html). 
* Please make sure to check our other projects at [loosolab](http://loosolab.mpi-bn.mpg.de/).

## License
This project is licensed under the MIT license.
