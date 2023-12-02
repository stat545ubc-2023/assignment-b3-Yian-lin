# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

### Features in my app:
# 1. Allow users to filter by neighborhoods in Vancouver. This feature is useful
# because users may only want to look at or download tree data for one or some
# neighborhoods.
# 2. Use the DT package to turn a static table into an interactive table. This 
# feature is useful because now users can interact with the table. For example,
# they can decide how many observations should be shown per page, and they can
# sort the table by any variable.
# 3. Allow users to download the table as a .csv file. This feature is useful 
# because users can not only look at the data, but also download the whole dataset
# or a subset of it (i.e. data for trees in one or some neighborhoods) as a .csv file.
# 4. Use a theme to make the app look prettier.
# 5. Added an image to the UI to make the app look prettier.
# 6. Added an introduction of the app to the UI so that users can know what
# this app is about and how to use it.


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

# Define UI for application that returns a table
ui <- fluidPage(
 
    #Use a theme
    theme = bslib::bs_theme(bootswatch = "sketchy", primary = "#38ad86", secondary = "#38ad86"),
    
    #Add a fluid row
    fluidRow(column(3, # add an image
                    br(), #add a line break
                    HTML('<center><img src="image.jpeg" width=280></center>'), #add the image
                    br()
                    ),
             
             column(9, # add a brief introduction
                    
                    br(),
                    
                    h1("Trees in Vancouver"),
                    
                    p("This is an app that displays data for individual trees in Vancouver.
                      Please feel free to filter the dataset by neighborhoods and download 
                      the filtered dataset as a .csv file. Please remember to uncheck the 
                      box of \"All\" if you only want to see or download data for trees 
                      within one or some neighborhoods. To explore the dataset, you can 
                      interact with the data table below by scrolling on both the x and y 
                      axes, sorting the table by any variable, and searching through the table.", 
                      style = "font-size:20px;"),
                    
                    p(strong("Source of data:"), "the vancouver_trees dataset in the", 
                      a("datateachr R package", href = "https://github.com/UBC-MDS/datateachr"),
                      style = "font-size:20px;"),
                    
                    br()
                    
                    )),


    # Add a Sidebar layout
    sidebarLayout(
        #Sidebar Panel: checkbox group input for neighbourhoods
        sidebarPanel(
            width = 3,
            
            ### Inputs
            checkboxGroupInput("neigInput",
                        "Neighbourhoods:", 
                        choices = c("All", unique(vancouver_trees$neighbourhood_name)),
                        selected = c("All")),
            # The download button
            downloadButton("downloadData", "Download data (csv)"),
            
            br(),
        ),

        #Main Panel
        mainPanel(
          width = 9,
          # Add a headline
          h3("Data"),
          ### Outputs 
          #Show a table
          DT::dataTableOutput("table_returned")
        )
    )
)

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
