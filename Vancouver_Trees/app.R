# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

library(shiny)
library(dplyr)
library(DT)

# Read in data
vancouver_trees <- read.csv("vancouver_trees.csv")
# tidy dataframe
vancouver_trees$tree_id <- as.integer(vancouver_trees$tree_id)
# select only a few columns
vancouver_trees <- vancouver_trees %>% 
  select(-c(std_street,cultivar_name, on_street_block,genus_name,
            civic_number, plant_area, street_side_name, assigned, on_street))

# Define UI for application that return a table
ui <- fluidPage(

    # Application title
    titlePanel("Trees in Vancouver"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            ### Inputs
            checkboxGroupInput("neigInput",
                        "Neighbourhoods:", 
                        choices = c("All", unique(vancouver_trees$neighbourhood_name)),
                        selected = c("All")),
            # The download button
            downloadButton("downloadData", "Download data (csv)")
            
        ),

        mainPanel(
          ### Outputs 
          #Show a table
          DT::dataTableOutput("table_returned")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    # Reactive expression for filtered data
    filtered <- reactive({
      if ("All" %in% input$neigInput) {
        vancouver_trees
      } else {
        vancouver_trees %>% filter(neighbourhood_name %in% input$neigInput)
      }
    })
    
    #build outputs
    #render a table
    output$table_returned <- DT::renderDataTable(
      filtered(),
      options = list(scrollX = TRUE,   ## enable scrolling on X axis
                     scrollY = TRUE)   ## enable scrolling on Y axis
    )
    
    #download dataset
    output$downloadData <- downloadHandler(
      filename = "vancouver_trees_selected.csv",
      content = function(file) {
        # Write the dataset to the `file` that will be downloaded
        write.csv(filtered(), file)
      }
    )
    
}

# Run the application 
shinyApp(ui = ui, server = server)
