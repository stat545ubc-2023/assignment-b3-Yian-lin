# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

### Features in my app:
# 1. Allow users to filter by neighborhoods in Vancouver. This feature is useful
# because users may only want to look at or download tree data for one or some
# neighborhoods.
# 2. The number of observations found whenever the filter changes is shown at
# the bottom of the table. This feature is useful because users can know clearly
# the number of observations found after applying the filter.
# 3. Use the DT package to turn a static table into an interactive table. This 
# feature is useful because now users can interact with the table. For example,
# they can decide how many observations should be shown per page, and they can
# sort the table by any variable.
# 4. Allow users to download the table as a .csv file. This feature is useful 
# because users can not only look at the data, but also download the data as a
# .csv file.

library(shiny)
library(dplyr)
library(DT)

# Read in data
vancouver_trees <- read.csv("vancouver_trees.csv")
# tidy dataframe
vancouver_trees$tree_id <- as.integer(vancouver_trees$tree_id)
# select some columns
vancouver_trees <- vancouver_trees %>% 
  select(-c(std_street,cultivar_name, on_street_block,genus_name,
            civic_number, plant_area, street_side_name, assigned, on_street))

# Define UI for application that return a table
ui <- fluidPage(

    # Application title
    titlePanel("Trees in Vancouver"),

    # Sidebar with a checkbox group input for neighbourhoods
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
