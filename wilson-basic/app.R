#
# WIlsON: Webbased Interactive Omics visualizatioN
# Basic App
#

# Dependency check
if(!requireNamespace("wilson", quietly = TRUE)) { stop("The package wilson needs to be installed in order to use this app.")}
if(!requireNamespace("shinydashboard", quietly = TRUE)) { stop("The package shinydashboard needs to be installed in order to use this app.")}
if(!requireNamespace("shinythemes", quietly = TRUE)) { stop("The package shinythemes needs to be installed in order to use this app.")}
if(!requireNamespace("shinyBS", quietly = TRUE)) { stop("The package shinyBS needs to be installed in order to use this app.")}
if(!requireNamespace("htmltools", quietly = TRUE)) { stop("The package htmltools needs to be installed in order to use this app.")}

# Set versions
wilson_app_version <- "WIlsON basic 2.1.0"
wilson_package_version <- as.character(packageVersion("wilson"))

#
# UI options
#
# width of the side panel
wilson_sidepanelwidth <- Sys.getenv("WILSON_SIDEPANELWIDTH", unset = 2)

# width of the main panel
wilson_mainpanelwidth <- Sys.getenv("WILSON_MAINPANELWIDTH", unset = 10)

# Which page should the user land on - default is the Introdcution page
wilson_landing_page <- match.arg(arg = Sys.getenv("WILSON_LANDING_PAGE", unset = "introduction"),
                                 choices = c("introduction", "feature_selection"))

#
# Server options
#
# Allow the server to print messages to the console
wilson_logging <- FALSE

# Redirect stdout to stderr when run on a server. This will print all output into the log file.
wilson_redirect_stdout <- FALSE

# Enable logging of reactive events, which can be viewed later with the showReactLog function. This incurs a substantial performance penalty and should not be used in production.
wilson_enable_reactive_event_logging <- FALSE

# Enable automatic reload of files that change during the runtime. All connected Shiny sessions will be reloaded. This incurs a substantial performance penalty and should not be used in production.
wilson_enable_auto_reload <- TRUE

# Customize the patterns for files that shiny will monitor for automatic reloading
wilson_auto_reload_pattern <- ".*\\.(r|se|R|clarion)$"
# wilson_auto_reload_pattern <- ".*\\.(r|html?|js|css|png|jpe?g|gif)$"

# Sets the auto reload polling interval in milliseconds
wilson_auto_reload_interval <- 3000

# Sets the max file upload size in mb
# This value only changes upload size of the shiny-server preceeding services (e.g. reverse proxy) must be altered aswell.
wilson_max_upload_size <- 100

# Allow logging of uploaded files for debugging purposes
wilson_log_upload <- TRUE

#
# WIlsON application logic
#
if (wilson_logging) options(shiny.trace = TRUE)
if (wilson_enable_reactive_event_logging) options(shiny.reactlog = TRUE)
if (wilson_enable_auto_reload) {
  options(shiny.autoreload = TRUE)
  options(shiny.autoreload.pattern = wilson_auto_reload_pattern)
  options(shiny.autoreload.interval = wilson_auto_reload_interval)
}
options(shiny.maxRequestSize = wilson_max_upload_size * 1024^2)

# Redirect stdout to stderr when running on server. All output will end up in the log file
if (wilson_redirect_stdout & !interactive() ) {
  sink(stderr(), type = "output")
}

# create version info
version_info <- paste0("---- VERSIONS ----\n",
                       "App: ", wilson_app_version, "\n",
                       "Package: ", wilson_package_version)

# Load packages
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyBS)
library(shinythemes)
library(log4r)
library(wilson)

# Define the UI
ui <- dashboardPage(header = dashboardHeader(disable = TRUE), sidebar = dashboardSidebar(disable = TRUE),
                    body = dashboardBody(
                      useShinyjs(),
                      tags$style(type = "text/css", "body {padding-top: 60px;}"),
                      tags$style(type = "text/css",
                                 "pre[id*='filter'] {font-size: 10px;}
                                  pre[id*='log'] {height: 200px; font-size: 10px}"),
                      tags$head(tags$link(rel = "icon", type = "image/png", href = "wilson_icon.png"),
                                # disable tabs on load
                                tags$script(
                                  "window.onload = function() {
                                    $('#top-menu a:contains(\"Geneview\")').addClass('disabled').parent().addClass('disabled');
                                    $('#top-menu a:contains(\"Data Reduction\")').addClass('disabled').parent().addClass('disabled');
                                    $('#top-menu a:contains(\"Scatterplot\")').addClass('disabled').parent().addClass('disabled');
                                    $('#top-menu a:contains(\"Heatmap\")').addClass('disabled').parent().addClass('disabled');
                                  };"
                                ),
                                # custom dropdown width
                                tags$style(
                                  HTML("#fileLoader + div>.selectize-dropdown{
                                          width: 300px !important;
                                        }
                                       #fileLoader + div>.selectize-input{
                                          overflow: auto;
                                       }")
                                )
                      ),
                      titlePanel(title = "", windowTitle = "WIlsON"),
                      navbarPage(title = div(style = "margin-left: -15px; margin-top: -20px", img(src = "wilson_header.png", width = "auto", height = "63px", style = "margin-right: -15px;", title = version_info)),
                                 theme = shinytheme("sandstone"),
                                 position = "fixed-top",
                                 id = "top-menu",
                                 selected = wilson_landing_page,
                                 # introduction ------------------------------------------------------------
                                 tabPanel(
                                   title = "Introduction",
                                   column(
                                     width = 7,
                                     offset = 2,
                                     includeMarkdown(file.path("introduction", "intro.md"))
                                   ),
                                   value = "introduction"
                                 ),
                                 # feature Selection -------------------------------------------------------
                                 tabPanel(title = "Feature Selection",
                                          sidebarLayout(
                                            sidebarPanel(width = wilson_sidepanelwidth,
                                                         tags$h6("Selected Features"),
                                                         verbatimTextOutput("filter1"),
                                                         tags$h6("Highlighted Features"),
                                                         verbatimTextOutput("filter_h1"),
                                                         tags$h3("Global Parameters"),
                                                         radioButtons(inputId = "data_origin", label = "Choose data origin:", choices = c("Examples", "Upload")),
                                                         uiOutput(outputId = "fileLoader"),
                                                         bsButton("filter_log_b", label = "Toggle log", style = "default", size = "small"),
                                                         hidden(verbatimTextOutput("filter_log"))
                                            ),
                                            mainPanel(width = wilson_mainpanelwidth,
                                                      tabBox(width = 12,
                                                             tabPanel(title = "Data",
                                                                      featureSelectorUI("featureSelector")
                                                             ),
                                                             tabPanel(title = "Highlight",
                                                                      featureSelectorUI("featureSelector_h")
                                                             )
                                                      )
                                            )
                                          ),
                                          value = "feature_selection"
                                 ),
                                 # geneview ---------------------------------------------------------------
                                 navbarMenu(
                                   title = "Geneview",
                                   tabPanel(title = "static",
                                            sidebarLayout(
                                              sidebarPanel(width = wilson_sidepanelwidth,
                                                           tags$h6("Selected Features"),
                                                           verbatimTextOutput("filter_geneviewer_static"),
                                                           tags$h6("Highlighted Features"),
                                                           verbatimTextOutput("filter_h_geneviewer_static"),
                                                           tags$h3("Global Parameters"),
                                                           numericInput(inputId = "width_geneviewer_static", label = "Width in cm", value = 0, min = 0),
                                                           numericInput(inputId = "height_geneviewer_static", label = "Height in cm", value = 0, min = 0),
                                                           sliderInput(inputId = "scale_geneviewer_static", label = "Scaling factor", min = 1, max = 10, value = 1, step = 0.1),
                                                           bsButton("geneviewer_static_log_b", label = "Toggle log", style = "default", size = "small"),
                                                           hidden(verbatimTextOutput("geneviewer_static_log"))
                                              ),
                                              mainPanel(width = wilson_mainpanelwidth,
                                                        tabBox(width = 12, selected = "GeneViewer",
                                                               tabPanel(title = "GeneViewer",
                                                                        geneViewUI("geneviewer_static")
                                                               ),
                                                               tabPanel(title = "Data",
                                                                        dataTableOutput("geneviewer_static_table")
                                                               )
                                                        )
                                              )
                                            ),
                                            value = "geneview_static"
                                   ),
                                   tabPanel(title = "interactive",
                                            sidebarLayout(
                                              sidebarPanel(width = wilson_sidepanelwidth,
                                                           tags$h6("Selected Features"),
                                                           verbatimTextOutput("filter_geneviewer_interactive"),
                                                           tags$h6("Highlighted Features"),
                                                           verbatimTextOutput("filter_h_geneviewer_interactive"),
                                                           tags$h3("Global Parameters"),
                                                           numericInput(inputId = "width_geneviewer_interactive", label = "Width in cm", value = 0, min = 0),
                                                           numericInput(inputId = "height_geneviewer_interactive", label = "Height in cm", value = 0, min = 0),
                                                           sliderInput(inputId = "scale_geneviewer_interactive", label = "Scaling factor", min = 1, max = 10, value = 1, step = 0.1),
                                                           bsButton("geneviewer_interactive_log_b", label = "Toggle log", style = "default", size = "small"),
                                                           hidden(verbatimTextOutput("geneviewer_interactive_log"))
                                              ),
                                              mainPanel(width = wilson_mainpanelwidth,
                                                        tabBox(width = 12, selected = "GeneViewer",
                                                               tabPanel(title = "GeneViewer",
                                                                        geneViewUI("geneviewer_interactive")
                                                               ),
                                                               tabPanel(title = "Data",
                                                                        dataTableOutput("geneviewer_interactive_table")
                                                               )
                                                        )
                                              )
                                            ),
                                            value = "geneview_interactive"
                                   )
                                 ),
                                 # data reduction ----------------------------------------------------------
                                 navbarMenu(
                                   title = "Data Reduction",
                                   tabPanel(title = "PCA",
                                            sidebarLayout(
                                              sidebarPanel(width = wilson_sidepanelwidth,
                                                           tags$h6("Selected Features"),
                                                           verbatimTextOutput("filter_pca"),
                                                           tags$h6("Highlighted Features"),
                                                           verbatimTextOutput("filter_h_pca"),
                                                           tags$h3("Global Parameters"),
                                                           numericInput(inputId = "width_pca", label = "Width in cm", value = 0, min = 0),
                                                           numericInput(inputId = "height_pca", label = "Height in cm", value = 0, min = 0),
                                                           sliderInput(inputId = "scale_pca", label = "Scaling factor", min = 1, max = 10, value = 1, step = 0.1),
                                                           bsButton("pca_log_b", label = "Toggle log", style = "default", size = "small"),
                                                           hidden(verbatimTextOutput("pca_log"))
                                              ),
                                              mainPanel(width = wilson_mainpanelwidth,
                                                        tabBox(width = 12, selected = "PCA", id = "pca_tabs",
                                                               tabPanel(title = "PCA",
                                                                        pcaUI("pca")
                                                               ),
                                                               tabPanel(title = "Data",
                                                                        uiOutput("pca_data_tabs")
                                                               )
                                                        )
                                              )
                                            ),
                                            value = "data_reduction_pca"
                                   ),
                                   tabPanel(title = "Global Correlation Heatmap",
                                            sidebarLayout(
                                              sidebarPanel(width = wilson_sidepanelwidth,
                                                           tags$h6("Selected Features"),
                                                           verbatimTextOutput("filter_global_cor_heatmap"),
                                                           tags$h6("Highlighted Features"),
                                                           verbatimTextOutput("filter_h_global_cor_heatmap"),
                                                           tags$h3("Global Parameters"),
                                                           numericInput(inputId = "width_global_cor_heatmap", label = "Width in cm", value = 0, min = 0),
                                                           numericInput(inputId = "height_global_cor_heatmap", label = "Height in cm", value = 0, min = 0),
                                                           sliderInput(inputId = "scale_global_cor_heatmap", label = "Scaling factor", min = 1, max = 10, value = 2, step = 0.1),
                                                           bsButton("global_cor_heatmap_log_b", label = "Toggle log", style = "default", size = "small"),
                                                           hidden(verbatimTextOutput("global_cor_heatmap_log"))
                                              ),
                                              mainPanel(width = wilson_mainpanelwidth,
                                                        tabBox(width = 12, selected = "Global correlation heatmap",
                                                               tabPanel(title = "Global correlation heatmap",
                                                                        global_cor_heatmapUI("glob_cor_heat")
                                                               ),
                                                               tabPanel(title = "Data",
                                                                        dataTableOutput("glob_cor_heat_data")
                                                               )
                                                        )
                                              )
                                            ),
                                            value = "data_reduction_global_correlation_heatmap"
                                   )
                                 ),
                                 # scatterplot -------------------------------------------------------------
                                 navbarMenu(
                                   title = "Scatterplot",
                                   "Static",
                                   tabPanel(
                                     title = "Simple Scatter",
                                     sidebarLayout(
                                       sidebarPanel(width = wilson_sidepanelwidth,
                                                    tags$h6("Selected Features"),
                                                    verbatimTextOutput("filter_simple_scatter_static"),
                                                    tags$h6("Highlighted Features"),
                                                    verbatimTextOutput("filter_h_simple_scatter_static"),
                                                    tags$h3("Global Parameters"),
                                                    numericInput(inputId = "width_simple_scatter_static", label = "Width in cm", value = 0, min = 0),
                                                    numericInput(inputId = "height_simple_scatter_static", label = "Height in cm", value = 0, min = 0),
                                                    sliderInput(inputId = "scale_simple_scatter_static", label = "Scaling factor", min = 1, max = 10, value = 1, step = 0.1),
                                                    markerUI("marker_simple_scatter_static"),
                                                    bsButton("simple_scatter_static_log_b", label = "Toggle log", style = "default", size = "small"),
                                                    hidden(verbatimTextOutput("simple_scatter_static_log"))
                                       ),
                                       mainPanel(width = wilson_mainpanelwidth,
                                                 tabBox(width = 12, selected = "Simple Scatter",
                                                        tabPanel(title = "Simple Scatter",
                                                                 scatterPlotUI("simple_scatter_static")
                                                        ),
                                                        tabPanel(title = "Data",
                                                                 dataTableOutput("simple_scatter_static_table")
                                                        )
                                                 )
                                       )
                                     ),
                                     value = "scatterplot_static_simple"
                                   ),
                                   tabPanel(
                                     title = "Duoscatter",
                                     sidebarLayout(
                                       sidebarPanel(width = wilson_sidepanelwidth,
                                                    tags$h6("Selected Features"),
                                                    verbatimTextOutput("filter_duoscatter_static"),
                                                    tags$h6("Highlighted Features"),
                                                    verbatimTextOutput("filter_h_duoscatter_static"),
                                                    tags$h3("Global Parameters"),
                                                    numericInput(inputId = "width_duoscatter_static", label = "Width in cm", value = 0, min = 0),
                                                    numericInput(inputId = "height_duoscatter_static", label = "Height in cm", value = 0, min = 0),
                                                    sliderInput(inputId = "scale_duoscatter_static", label = "Scaling factor", min = 1, max = 10, value = 1, step = 0.1),
                                                    markerUI("marker_duoscatter_static"),
                                                    bsButton("duoscatter_static_log_b", label = "Toggle log", style = "default", size = "small"),
                                                    hidden(verbatimTextOutput("duoscatter_static_log"))
                                       ),
                                       mainPanel(width = wilson_mainpanelwidth,
                                                 tabBox(width = 12, selected = "Duoscatter",
                                                        tabPanel(title = "Data (left)",
                                                                 dataTableOutput("duoscatter_static_table_1")
                                                        ),
                                                        tabPanel(title = "Duoscatter",
                                                                 fluidRow(
                                                                   column(width = 6,
                                                                          scatterPlotUI("duoscatter_static_1")
                                                                   ),
                                                                   column(width = 6,
                                                                          scatterPlotUI("duoscatter_static_2")
                                                                   )
                                                                 )
                                                        ),
                                                        tabPanel(title = "Data (right)",
                                                                 dataTableOutput("duoscatter_static_table_2")
                                                        )
                                                 )
                                       )
                                     ),
                                     value = "scatterplot_static_duoscatter"
                                   ),
                                   "Interactive",
                                   tabPanel(
                                     title = "Simple Scatter",
                                     sidebarLayout(
                                       sidebarPanel(width = wilson_sidepanelwidth,
                                                    tags$h6("Selected Features"),
                                                    verbatimTextOutput("filter_simple_scatter_interactive"),
                                                    tags$h6("Highlighted Features"),
                                                    verbatimTextOutput("filter_h_simple_scatter_interactive"),
                                                    tags$h3("Global Parameters"),
                                                    numericInput(inputId = "width_simple_scatter_interactive", label = "Width in cm", value = 0, min = 0),
                                                    numericInput(inputId = "height_simple_scatter_interactive", label = "Height in cm", value = 0, min = 0),
                                                    sliderInput(inputId = "scale_simple_scatter_interactive", label = "Scaling factor", min = 1, max = 10, value = 1, step = 0.1),
                                                    markerUI("marker_simple_scatter_interactive"),
                                                    bsButton("simple_scatter_interactive_log_b", label = "Toggle log", style = "default", size = "small"),
                                                    hidden(verbatimTextOutput("simple_scatter_interactive_log"))
                                       ),
                                       mainPanel(width = wilson_mainpanelwidth,
                                                 tabBox(width = 12, selected = "Simple Scatter",
                                                        tabPanel(title = "Simple Scatter",
                                                                 scatterPlotUI("simple_scatter_interactive")
                                                        ),
                                                        tabPanel(title = "Data",
                                                                 dataTableOutput("simple_scatter_interactive_table")
                                                        )
                                                 )
                                       )
                                     ),
                                     value = "scatterplot_interactive_simple"
                                   ),
                                   tabPanel(
                                     title = "Duoscatter",
                                     sidebarLayout(
                                       sidebarPanel(width = wilson_sidepanelwidth,
                                                    tags$h6("Selected Features"),
                                                    verbatimTextOutput("filter_duoscatter_interactive"),
                                                    tags$h6("Highlighted Features"),
                                                    verbatimTextOutput("filter_h_duoscatter_interactive"),
                                                    tags$h3("Global Parameters"),
                                                    numericInput(inputId = "width_duoscatter_interactive", label = "Width in cm", value = 0, min = 0),
                                                    numericInput(inputId = "height_duoscatter_interactive", label = "Height in cm", value = 0, min = 0),
                                                    sliderInput(inputId = "scale_duoscatter_interactive", label = "Scaling factor", min = 1, max = 10, value = 1, step = 0.1),
                                                    markerUI("marker_duoscatter_interactive"),
                                                    bsButton("duoscatter_interactive_log_b", label = "Toggle log", style = "default", size = "small"),
                                                    hidden(verbatimTextOutput("duoscatter_interactive_log"))
                                       ),
                                       mainPanel(width = wilson_mainpanelwidth,
                                                 tabBox(width = 12, selected = "Duoscatter",
                                                        tabPanel(title = "Data (left)",
                                                                 dataTableOutput("duoscatter_interactive_table_1")
                                                        ),
                                                        tabPanel(title = "Duoscatter",
                                                                 fluidRow(
                                                                   column(width = 6,
                                                                          scatterPlotUI("duoscatter_interactive_1")
                                                                   ),
                                                                   column(width = 6,
                                                                          scatterPlotUI("duoscatter_interactive_2")
                                                                   )
                                                                 )
                                                        ),
                                                        tabPanel(title = "Data (right)",
                                                                 dataTableOutput("duoscatter_interactive_table_2")
                                                        )
                                                 )
                                       )
                                     ),
                                     value = "scatterplot_interactive_duoscatter"
                                   )
                                 ),
                                 # heatmap -----------------------------------------------------------------
                                 navbarMenu(
                                   title = "Heatmap",
                                   tabPanel(title = "Static",
                                            sidebarLayout(
                                              sidebarPanel(width = wilson_sidepanelwidth,
                                                           tags$h6("Selected Features"),
                                                           verbatimTextOutput("filter_heatmap_static"),
                                                           tags$h6("Highlighted Features"),
                                                           verbatimTextOutput("filter_h_heatmap_static"),
                                                           tags$h3("Global Parameters"),
                                                           numericInput(inputId = "width_heatmap_static", label = "Width in cm", value = 0, min = 0),
                                                           numericInput(inputId = "height_heatmap_static", label = "Height in cm", value = 0, min = 0),
                                                           sliderInput(inputId = "scale_heatmap_static", label = "Scaling factor", min = 1, max = 10, value = 1, step = 0.1),
                                                           bsButton("heatmap_static_log_b", label = "Toggle log", style = "default", size = "small"),
                                                           hidden(verbatimTextOutput("heatmap_static_log"))
                                              ),
                                              mainPanel(width = wilson_mainpanelwidth,
                                                        tabBox(width = 12, selected = "Heatmap",
                                                               tabPanel(title = "Heatmap",
                                                                        heatmapUI("heatmap_static")
                                                               ),
                                                               tabPanel(title = "Data",
                                                                        dataTableOutput("heatmap_static_table")
                                                               )
                                                        )
                                              )
                                            ),
                                            value = "heatmap_static"
                                   ),
                                   tabPanel(title = "Interactive",
                                            sidebarLayout(
                                              sidebarPanel(width = wilson_sidepanelwidth,
                                                           tags$h6("Selected Features"),
                                                           verbatimTextOutput("filter_heatmap_interactive"),
                                                           tags$h6("Highlighted Features"),
                                                           verbatimTextOutput("filter_h_heatmap_interactive"),
                                                           tags$h3("Global Parameters"),
                                                           numericInput(inputId = "width_heatmap_interactive", label = "Width in cm", value = 0, min = 0),
                                                           numericInput(inputId = "height_heatmap_interactive", label = "Height in cm", value = 0, min = 0),
                                                           sliderInput(inputId = "scale_heatmap_interactive", label = "Scaling factor", min = 1, max = 10, value = 1, step = 0.1),
                                                           bsButton("heatmap_interactive_log_b", label = "Toggle log", style = "default", size = "small"),
                                                           hidden(verbatimTextOutput("heatmap_interactive_log"))
                                              ),
                                              mainPanel(width = wilson_mainpanelwidth,
                                                        tabBox(width = 12, selected = "Heatmap",
                                                               tabPanel(title = "Heatmap",
                                                                        heatmapUI("heatmap_interactive", row.label = FALSE)
                                                               ),
                                                               tabPanel(title = "Data",
                                                                        dataTableOutput("heatmap_interactive_table")
                                                               )
                                                        )
                                              )
                                            ),
                                            value = "heatmap_interactive"
                                   )
                                 )
                      )
                    )
)

server <- function(session, input, output) {
  # Session token
  message("Session: ", session$token)

  # logging
  if (!dir.exists("logs")) {
    dir.create("logs")
  }

  logger <- create.logger(logfile = file.path("logs", paste0(session$token, ".log")), level = "INFO")
  set_logger(logger, token = session$token)

  # delete logger on session end
  onSessionEnded(function() {
    set_logger(NULL, token = session$token)
  })

  # read log
  log <- reactiveFileReader(intervalMillis = 100, session = session, filePath = file.path("logs", paste0(session$token, ".log")), readFunc = readLines)

  # show log
  prepare_log <- reactive(paste(log(), collapse = "\n"))
  output$filter_log <- output$geneviewer_static_log <- output$geneviewer_interactive_log <- output$pca_log <- output$global_cor_heatmap_log <- output$simple_scatter_static_log <- output$simple_scatter_interactive_log <- output$duoscatter_static_log <- output$duoscatter_interactive_log <- output$heatmap_static_log <- output$heatmap_interactive_log <- renderText(prepare_log())

  observeEvent(ignoreNULL = FALSE, ignoreInit = TRUE, {
    input$filter_log_b
    input$geneviewer_static_log_b
    input$geneviewer_interactive_log_b
    input$pca_log_b
    input$global_cor_heatmap_log_b
    input$simple_scatter_static_log_b
    input$simple_scatter_interactive_log_b
    input$duoscatter_static_log_b
    input$duoscatter_interactive_log_b
    input$heatmap_static_log_b
    input$heatmap_interactive_log_b
  }, {
    toggle("filter_log")
    toggle("geneviewer_static_log")
    toggle("geneviewer_interactive_log")
    toggle("pca_log")
    toggle("global_cor_heatmap_log")
    toggle("simple_scatter_static_log")
    toggle("simple_scatter_interactive_log")
    toggle("duoscatter_static_log")
    toggle("duoscatter_interactive_log")
    toggle("heatmap_static_log")
    toggle("heatmap_interactive_log")
  })

  #
  # Data options
  #
  # Use all .se and .clarion files specified in data
  load <- sapply(list.files(path = "data", pattern = "\\.se$|\\.clarion$"), function(x){ file.path("data", x)})

  # check for additional data
  if (dir.exists("external_data")) {
    # use all .se and .clarion files specified in external_data
    external <- sapply(list.files(path = "external_data", pattern = "\\.se$|\\.clarion$"), function(x){ file.path("external_data", x)})

    if (length(external) > 0) {
      # omit duplicated names from load
      load <- load[setdiff(names(load), names(external))]
      # merge file lists
      load <- c(load, external)
      # sort by name
      load <- load[order(names(load))]
    }
  }

  output$fileLoader <- renderUI({
    shiny::req(input$data_origin)

    if (input$data_origin == "Examples") {
      return(selectizeInput(inputId = "fileLoader", label = "Select data set", choices = load, selected = input$fileLoader))
    } else if (input$data_origin == "Upload") {
      return(fileInput(inputId = "fileLoader2", label = "Upload clarion file", accept = c(".se", ".clarion")))
    }
  })

  # last upload filepath; prevents loading of last upload
  last_upload <- reactiveVal(value = "")
  # returns filepath
  file_path <- eventReactive({
    if (isTruthy(input$fileLoader) && input$data_origin == "Examples") {
      return(TRUE)
    } else if (isTruthy(input$fileLoader2$datapath) && input$data_origin == "Upload" && input$fileLoader2$datapath != isolate(last_upload())) {
      last_upload(input$fileLoader2$datapath)

      return(TRUE)
    }
  }, {
    if (input$data_origin == "Examples") {
      shiny::req(input$fileLoader)

      return(list(path = input$fileLoader, name = input$fileLoader))
    } else if (input$data_origin == "Upload") {
      shiny::req(input$fileLoader2$datapath)

      # copy for debugging
      if (wilson_log_upload) {
        # file name = session_date_filename
        date <- strftime(x = Sys.time(), format = "%Y%m%d-%H%M%S")
        file.copy(from = input$fileLoader2$datapath, to = file.path("logs", paste(session$token, date, input$fileLoader2$name, sep = "_")))
      }

      return(list(path = input$fileLoader2$datapath, name = input$fileLoader2$name))
    }
  })

  # Load and parse data
  parsed <- reactive({
    shiny::req(file_path())

    file <- try(parser(file_path()$path))

    if (!isTruthy(file)) {
      error(logger, paste("Couldn't parse", file_path()$name, file))
      showNotification(
        id = "parsing-error",
        paste0("Error parsing file ", file_path()$name, "."),
        file,
        duration = NULL,
        type = "error"
      )

      shinyjs::addClass(selector = "#shiny-notification-parsing-error", class = "notification-position-center")
    } else {
      info(logger, paste("Parsing file", file_path()$name))
      removeNotification(id = "parsing-error")
    }

    shiny::req(file)
  })

  # featureSelection --------------------------------------------------------
  fs <- callModule(featureSelector, "featureSelector", clarion = parsed)
  fsh <- callModule(featureSelector, "featureSelector_h", clarion = reactive(fs()$object), selection.default = "none")

  # show filter selection
  text <- reactive(paste(fs()$filter, collapse = "\n"))
  output$filter1 <- output$filter_geneviewer_static <- output$filter_geneviewer_interactive <- output$filter_pca <- output$filter_global_cor_heatmap <- output$filter_simple_scatter_static <- output$filter_simple_scatter_interactive <- output$filter_duoscatter_static <- output$filter_duoscatter_interactive <- output$filter_heatmap_static <- output$filter_heatmap_interactive <- renderText(text())
  # show filter highlight selection
  text_h <- reactive(paste(fsh()$filter, collapse = "\n"))
  output$filter_h1 <- output$filter_h_geneviewer_static <- output$filter_h_geneviewer_interactive <- output$filter_h_pca <- output$filter_h_global_cor_heatmap <- output$filter_h_simple_scatter_static <- output$filter_h_simple_scatter_interactive <- output$filter_h_duoscatter_static <- output$filter_h_duoscatter_interactive <- output$filter_h_heatmap_static <- output$filter_h_heatmap_interactive <- renderText(text_h())

  # enable/ disable tabs
  observe({
    if (isTruthy(fs()$object)) {
      runjs(
        "$('#top-menu a:contains(\"Geneview\")').removeClass('disabled').parent().removeClass('disabled');
         $('#top-menu a:contains(\"Data Reduction\")').removeClass('disabled').parent().removeClass('disabled');
         $('#top-menu a:contains(\"Scatterplot\")').removeClass('disabled').parent().removeClass('disabled');
         $('#top-menu a:contains(\"Heatmap\")').removeClass('disabled').parent().removeClass('disabled');"
      )
    } else {
      runjs(
        "$('#top-menu a:contains(\"Geneview\")').addClass('disabled').parent().addClass('disabled');
         $('#top-menu a:contains(\"Data Reduction\")').addClass('disabled').parent().addClass('disabled');
         $('#top-menu a:contains(\"Scatterplot\")').addClass('disabled').parent().addClass('disabled');
         $('#top-menu a:contains(\"Heatmap\")').addClass('disabled').parent().addClass('disabled');"
      )
    }
  })

  # geneviewer --------------------------------------------------------------
  gene_static <- callModule(geneView, "geneviewer_static", clarion = reactive(fs()$object), plot.method = "static", width = reactive(input$width_geneviewer_static), height = reactive(input$height_geneviewer_static), scale = reactive(input$scale_geneviewer_static))
  gene_interactive <- callModule(geneView, "geneviewer_interactive", clarion = reactive(fs()$object), plot.method = "interactive", width = reactive(input$width_geneviewer_interactive), height = reactive(input$height_geneviewer_interactive), scale = reactive(input$scale_geneviewer_interactive))

  output$geneviewer_static_table <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    gene_static()
  })

  output$geneviewer_interactive_table <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    gene_interactive()
  })

  # data reduction ----------------------------------------------------------
  # pca
  pca <- callModule(pca, "pca", clarion = reactive(fs()$object), width = reactive(input$width_pca), height = reactive(input$height_pca), scale = reactive(input$scale_pca))

  output$pca_data_tabs <- renderUI({
    tabs <- lapply(names(pca()), function(name) {
      tabPanel(
        title = name,
        dataTableOutput(outputId = name)
      )
    })
    do.call(tabsetPanel, tabs)
  })

  observe({
    if (input$pca_tabs == "Data" & !is.null(pca())) {
      for (name in names(pca())) {
        #local so each item get's own id, else tables will be overwritten
        local({
          local_name <- name
          output[[local_name]] <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE),
                                                  pca()[[local_name]]
          )
        })
      }
    }
  })

  # global clustering heatmap
  glob_cor_table <- callModule(global_cor_heatmap, "glob_cor_heat", clarion = reactive(fs()$object), width = reactive(input$width_global_cor_heatmap), height = reactive(input$height_global_cor_heatmap), scale = reactive(input$scale_global_cor_heatmap))

  output$glob_cor_heat_data <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    glob_cor_table()
  })

  # scatterplot -------------------------------------------------------------
  ## static
  marker_simple_static <- callModule(marker, "marker_simple_scatter_static", clarion = reactive(fsh()$object))
  marker_duo_static <- callModule(marker, "marker_duoscatter_static", clarion = reactive(fsh()$object))

  scatter_static <- callModule(scatterPlot, "simple_scatter_static", clarion = reactive(fs()$object), marker.output = marker_simple_static, width = reactive(input$width_simple_scatter_static), height = reactive(input$height_simple_scatter_static), scale = reactive(input$scale_simple_scatter_static))
  duo_static_1 <- callModule(scatterPlot, "duoscatter_static_1", clarion = reactive(fs()$object), marker.output = marker_duo_static, width = reactive(input$width_duoscatter_static), height = reactive(input$height_duoscatter_static), scale = reactive(input$scale_duoscatter_static))
  duo_static_2 <- callModule(scatterPlot, "duoscatter_static_2", clarion = reactive(fs()$object), marker.output = marker_duo_static, width = reactive(input$width_duoscatter_static), height = reactive(input$height_duoscatter_static), scale = reactive(input$scale_duoscatter_static))

  output$simple_scatter_static_table <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    scatter_static()
  })
  output$duoscatter_static_table_1 <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    duo_static_1()
  })
  output$duoscatter_static_table_2 <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    duo_static_2()
  })

  ## interactive
  marker_simple_interactive <- callModule(marker, "marker_simple_scatter_interactive", clarion = reactive(fsh()$object))
  marker_duo_interactive <- callModule(marker, "marker_duoscatter_interactive", clarion = reactive(fsh()$object))

  scatter_interactive <- callModule(scatterPlot, "simple_scatter_interactive", clarion = reactive(fs()$object), marker.output = marker_simple_interactive, plot.method = "interactive", width = reactive(input$width_simple_scatter_interactive), height = reactive(input$height_simple_scatter_interactive), scale = reactive(input$scale_simple_scatter_interactive))
  duo_interactive_1 <- callModule(scatterPlot, "duoscatter_interactive_1", clarion = reactive(fs()$object), marker.output = marker_duo_interactive, plot.method = "interactive", width = reactive(input$width_duoscatter_interactive), height = reactive(input$height_duoscatter_interactive), scale = reactive(input$scale_duoscatter_interactive))
  duo_interactive_2 <- callModule(scatterPlot, "duoscatter_interactive_2", clarion = reactive(fs()$object), marker.output = marker_duo_interactive, plot.method = "interactive", width = reactive(input$width_duoscatter_interactive), height = reactive(input$height_duoscatter_interactive), scale = reactive(input$scale_duoscatter_interactive))

  output$simple_scatter_interactive_table <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    scatter_interactive()
  })
  output$duoscatter_interactive_table_1 <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    duo_interactive_1()
  })
  output$duoscatter_interactive_table_2 <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    duo_interactive_2()
  })

  # heatmap -----------------------------------------------------------------
  ## static
  heatmap_static_table <- callModule(heatmap, "heatmap_static", clarion = reactive(fs()$object), plot.method = "static", width = reactive(input$width_heatmap_static), height = reactive(input$height_heatmap_static), scale = reactive(input$scale_heatmap_static))

  output$heatmap_static_table <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    heatmap_static_table()
  })

  ## interactive
  heatmap_interactive_table <- callModule(heatmap, "heatmap_interactive", clarion = reactive(fs()$object), plot.method = "interactive", width = reactive(input$width_heatmap_interactive), height = reactive(input$height_heatmap_interactive), scale = reactive(input$scale_heatmap_interactive))

  output$heatmap_interactive_table <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    heatmap_interactive_table()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
