library(shiny)
library(DT)
library(shinydashboard)
library(shinythemes)
library(colourpicker)
library(wilson)

#
# Data options
#
# Specify the input file here
wilson_input <- "data/prmt5_example.se"

#
# UI options
#
# width of the side panel
wilson_sidepanelwidth <- 2

# width of the main panel
wilson_mainpanelwidth <- 10

#
# Server options
#
# Set to false to disable images from the wilson package
wilson_images_enabled <- TRUE

# Allow the server to print messages to the console
wilson_logging <- TRUE

# Redirect stdout to stderr when run on a server. This will print all output into the log file.
wilson_redirect_stdout <- FALSE

# Enable logging of reactive events, which can be viewed later with the showReactLog function. This incurs a substantial performance penalty and should not be used in production.
wilson_enable_reactive_event_logging <- FALSE

# Enable automatic reload of files that change during the runtime. All connected Shiny sessions will be reloaded. This incurs a substantial performance penalty and should not be used in production.
wilson_enable_auto_reload <- FALSE

# Customize the patterns for files that shiny will monitor for automatic reloading
wilson_auto_reload_pattern <- ".*\\.(r|se|R)$"
# wilson_auto_reload_pattern <- ".*\\.(r|html?|js|css|png|jpe?g|gif)$"

# Sets the auto reload polling interval in milliseconds
wilson_auto_reload_interval <- 3000

#
# WIlsON application logic
#
if (wilson_logging) options(shiny.trace = TRUE)
if (wilson_enable_reactive_event_logging) options(shiny.reactlog=TRUE)
if (wilson_images_enabled) shiny::addResourcePath(prefix = "wilson_www", directoryPath = "inst/www/")
if (wilson_enable_auto_reload) {
  options(shiny.autoreload = TRUE)
	options(shiny.autoreload.pattern = wilson_auto_reload_pattern)
	options(shiny.autoreload.interval = wilson_auto_reload_interval)
}

# Redirect stdout to stderr when running on server. All output will end up in the log file
if (wilson_redirect_stdout & !interactive() ) {
	sink(stderr(), type="output")
}

# Load and parse data
table <- parser(wilson_input)
data <- table$data
metadata <- table$metadata

# Define the UI
ui <- dashboardPage(header = dashboardHeader(disable = TRUE), sidebar = dashboardSidebar(disable = TRUE),
                    body = dashboardBody(
                      tags$style(type="text/css", "body {padding-top: 60px;}"),
                      tags$style(type="text/css",
                                 "#filter1,
                                 #filter_geneviewer_static,
                                 #filter_geneviewer_interactive,
                                 #filter_pca,
                                 #filter_global_cor_heatmap,
                                 #filter_simple_scatter_static,
                                 #filter_simple_scatter_interactive,
                                 #filter_duoscatter_static,
                                 #filter_duoscatter_interactive,
                                 #filter_heatmap_static,
                                 #filter_heatmap_interactive,
                                 #filter_h1,
                                 #filter_h_geneviewer_static,
                                 #filter_h_geneviewer_interactive,
                                 #filter_h_pca, #filter_h_global_cor_heatmap,
                                 #filter_h_simple_scatter_static,
                                 #filter_h_simple_scatter_interactive,
                                 #filter_h_duoscatter_static,
                                 #filter_h_duoscatter_interactive,
                                 #filter_h_heatmap_static,
                                 #filter_h_heatmap_interactive {font-size: 10px}"),
                      navbarPage(title = "WIlsON", theme = shinytheme("sandstone"), position = "fixed-top",
                                 # introduction ------------------------------------------------------------
                                 navbarMenu(
                                   title = "Introduction",
                                   start(),
                                   format()
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
                                                         uiOutput("features")
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
                                          )
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
                                                           tags$h3("Global Parameters")
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
                                            )
                                   ),
                                   tabPanel(title = "interactive",
                                            sidebarLayout(
                                              sidebarPanel(width = wilson_sidepanelwidth,
                                                           tags$h6("Selected Features"),
                                                           verbatimTextOutput("filter_geneviewer_interactive"),
                                                           tags$h6("Highlighted Features"),
                                                           verbatimTextOutput("filter_h_geneviewer_interactive"),
                                                           tags$h3("Global Parameters")
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
                                            )
                                   )
                                 )
                                 ,
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
                                                           tags$h3("Global Parameters")
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
                                            )
                                   ),
                                   tabPanel(title = "Global Correlation Heatmap",
                                            sidebarLayout(
                                              sidebarPanel(width = wilson_sidepanelwidth,
                                                           tags$h6("Selected Features"),
                                                           verbatimTextOutput("filter_global_cor_heatmap"),
                                                           tags$h6("Highlighted Features"),
                                                           verbatimTextOutput("filter_h_global_cor_heatmap"),
                                                           tags$h3("Global Parameters")
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
                                            )
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
                                                    markerUI("marker_simple_scatter_static")
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
                                     )
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
                                                    markerUI("marker_duoscatter_static")
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
                                     )
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
                                                    markerUI("marker_simple_scatter_interactive")
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
                                     )
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
                                                    markerUI("marker_duoscatter_interactive")
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
                                     )
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
                                                           tags$h3("Global Parameters")
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
                                            )
                                   ),
                                   tabPanel(title = "Interactive",
                                            sidebarLayout(
                                              sidebarPanel(width = wilson_sidepanelwidth,
                                                           tags$h6("Selected Features"),
                                                           verbatimTextOutput("filter_heatmap_interactive"),
                                                           tags$h6("Highlighted Features"),
                                                           verbatimTextOutput("filter_h_heatmap_interactive"),
                                                           tags$h3("Global Parameters")
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
                                            )
                                   )
                                 )

                      )
                    )
)

# Define the server function
server <- function(session, input, output) {
  text <- reactive(paste(fs()$filter, collapse = "\n"))
  output$filter1 <- output$filter_geneviewer_static <- output$filter_geneviewer_interactive <- output$filter_pca <- output$filter_global_cor_heatmap <- output$filter_simple_scatter_static <- output$filter_simple_scatter_interactive <- output$filter_duoscatter_static <- output$filter_duoscatter_interactive <- output$filter_heatmap_static <- output$filter_heatmap_interactive <- renderText(text())

  text_h <- reactive(paste(fsh()$filter, collapse = "\n"))
  output$filter_h1 <- output$filter_h_geneviewer_static <- output$filter_h_geneviewer_interactive <- output$filter_h_pca <- output$filter_h_global_cor_heatmap <- output$filter_h_simple_scatter_static <- output$filter_h_simple_scatter_interactive <- output$filter_h_duoscatter_static <- output$filter_h_duoscatter_interactive <- output$filter_h_heatmap_static <- output$filter_h_heatmap_interactive <- renderText(text_h())

  # featureSelection --------------------------------------------------------
  output$features <- renderUI({
    selectInput(inputId = "selectFeatures", label = "Features to select from", choices = metadata[[1]], multiple = TRUE)
  })

  fs <- callModule(featureSelector, "featureSelector", data = data, features = reactive(input$selectFeatures), feature.grouping = metadata[, c(1,3)], step = 100)
  fsh <- callModule(featureSelector, "featureSelector_h", data = reactive(fs()$data), features = reactive(input$selectFeatures), selection.default = "none")

  # geneviewer --------------------------------------------------------------
  gene_static <- callModule(geneView, "geneviewer_static", data = reactive(fs()$data), metadata = metadata, level = metadata[level != "feature"][["level"]], plot.method = "static")
  gene_interactive <- callModule(geneView, "geneviewer_interactive", data = reactive(fs()$data), metadata = metadata, level = metadata[level != "feature"][["level"]], plot.method = "interactive")

  output$geneviewer_static_table <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    gene_static()
  })

  output$geneviewer_interactive_table <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    gene_interactive()
  })

  # data reduction ----------------------------------------------------------
  # pca
  pca <- callModule(pca, "pca", data = reactive(fs()$data), metadata = metadata, level = metadata[level != "feature"][["level"]], entryLabel = "Ensembl gene")

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
    if(input$pca_tabs == "Data" & !is.null(pca())){
      for(name in names(pca())) {
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
  glob_cor_table <- callModule(global_cor_heatmap, "glob_cor_heat", data = reactive(fs()$data), types = metadata[level != "feature", c("key", "level")])

  output$glob_cor_heat_data <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    glob_cor_table()
  })

  # scatterplot -------------------------------------------------------------
  ## static
  marker_simple_static <- callModule(marker, "marker_simple_scatter_static", highlight.labels = reactive(names(fsh()$data)))
  marker_duo_static <- callModule(marker, "marker_duoscatter_static", highlight.labels = reactive(names(fsh()$data)))

  scatter_static <- callModule(scatterPlot, "simple_scatter_static", data = reactive(fs()$data), types = metadata[level != "feature", c("key", "level")], features = reactive(fsh()$data), markerReac = marker_simple_static, entryLabel = "Ensembl gene")
  duo_static_1 <- callModule(scatterPlot, "duoscatter_static_1", data = reactive(fs()$data), types = metadata[level != "feature", c("key", "level")], features = reactive(fsh()$data), markerReac = marker_duo_static, entryLabel = "Ensembl gene")
  duo_static_2 <- callModule(scatterPlot, "duoscatter_static_2", data = reactive(fs()$data), types = metadata[level != "feature", c("key", "level")], features = reactive(fsh()$data), markerReac = marker_duo_static, entryLabel = "Ensembl gene")

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
  marker_simple_interactive <- callModule(marker, "marker_simple_scatter_interactive", highlight.labels = reactive(names(fsh()$data)))
  marker_duo_interactive <- callModule(marker, "marker_duoscatter_interactive", highlight.labels = reactive(names(fsh()$data)))

  scatter_interactive <- callModule(scatterPlot, "simple_scatter_interactive", data = reactive(fs()$data), types = metadata[level != "feature", c("key", "level")], features = reactive(fsh()$data), markerReac = marker_simple_interactive, entryLabel = "Ensembl gene", plot.method = "interactive")
  duo_interactive_1 <- callModule(scatterPlot, "duoscatter_interactive_1", data = reactive(fs()$data), types = metadata[level != "feature", c("key", "level")], features = reactive(fsh()$data), markerReac = marker_duo_interactive, entryLabel = "Ensembl gene", plot.method = "interactive")
  duo_interactive_2 <- callModule(scatterPlot, "duoscatter_interactive_2", data = reactive(fs()$data), types = metadata[level != "feature", c("key", "level")], features = reactive(fsh()$data), markerReac = marker_duo_interactive, entryLabel = "Ensembl gene", plot.method = "interactive")

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
  heatmap_static_table <- callModule(heatmap, "heatmap_static", data = reactive(fs()$data), types = metadata[level != "feature", c("key", "level")], plot.method = "static", entryLabel = "Ensembl gene")

  output$heatmap_static_table <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    heatmap_static_table()
  })

  ## interactive
  heatmap_interactive_table <- callModule(heatmap, "heatmap_interactive", data = reactive(fs()$data), types = metadata[level != "feature", c("key", "level")], plot.method = "interactive", entryLabel = "Ensembl gene")

  output$heatmap_interactive_table <- renderDataTable(options = list(pageLength = 10, scrollX = TRUE), {
    heatmap_interactive_table()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
