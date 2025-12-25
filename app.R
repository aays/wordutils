box::use(shiny[...])
box::use(here[here])
box::use(dplyr[...])
box::use(ggplot2[...])
box::use(tidyr[...])
# box::use(officer[read_docx]) # if wanting to add ms word compatibility

box::use(./modules/ui_count)
box::use(./modules/server_count)


# Define UI for application that draws a histogram
ui <- navbarPage(
  'wordutils',
  
  tabPanel(
    'counts',
    sidebarLayout(
      sidebarPanel(ui_count$sidebar('counts'), width = 3),
      mainPanel(ui_count$main('counts'), width = 9)
    )
    
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  server_count$server('counts')
}

# Run the application 
shinyApp(ui = ui, server = server)
