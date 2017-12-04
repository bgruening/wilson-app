#' Function which returns a 'getting started' page
#'
#' @return Shiny tabPanel including 'getting started' markdown file.
#'
start <- function() {
  shiny::tabPanel(
    title = "Getting Started",
    shiny::sidebarLayout(
      sidebarPanel = shiny::sidebarPanel(width = 2,
                                         shiny::h3("Table of contents"),
                                         shiny::a("Examples", href = "#examples"), shiny::br(),
                                         shiny::a("Basic Structure", href = "#basic_structure"), shiny::br(),
                                         shiny::a("Feature Selection", href = "#feature_selection"), shiny::br(),
                                         shiny::a("Plots", href = "#plots"), shiny::br(),
                                         shiny::a("Interactivity", href = "#interactivity"), shiny::br(),
                                         shiny::a("Help", href = "#help"), shiny::br(),
                                         shiny::a("Use Cases", href = "#use_cases")
      ),
      mainPanel = shiny::mainPanel(width = 7,
                                   htmltools::includeMarkdown("introduction/intro.md")
      )
    )
  )
}

#' Function which returns a 'data format' page
#'
#' @return Shiny tabPanel including 'data format' markdown file.
#'
format <- function() {
  shiny::tabPanel(
    title = "Data Format",
    shiny::sidebarLayout(
      sidebarPanel = shiny::sidebarPanel(width = 2,
                                         shiny::h3("Table of contents"),
                                         shiny::a("Header", href = "#header"), shiny::br(),
                                         shiny::a("Metadata", href = "#metadata"), shiny::br(),
                                         shiny::a("Data", href = "#data")
      ),
      mainPanel = shiny::mainPanel(width = 7,
                                   htmltools::includeMarkdown("introduction/format.md")
      )
    )
  )
}
