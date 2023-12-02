## Introduction

### Description of the Shiny app
*Trees in Vancouver* is an app that displays a table of data for individual trees in Vancouver. This app allows users to filter the tree data by neighborhoods and download the filtered dataset as a .csv file. In addition, within the app, users can interact with the table. For example, users can decide how many observations are shown per page, sort the table by any variable, and search through the table.

### Link to the app
This Shiny app can be accessed through this link: https://yian-lin.shinyapps.io/Vancouver_Trees/.

### R code and data
R code and data used to build this app can be found in the `Vancouver_Trees` folder. The file *app.R* contains the R code used, and the file *vancouver_trees.csv* is the CSV-formatted version of the `vancouver_trees` dataset included in the [`datateachr` R package](https://github.com/UBC-MDS/datateachr). The data presented in this app is a subset of the *vancouver_trees.csv*. The R code used to create this subset can be found in lines 25 to 32 in *app.R*.






