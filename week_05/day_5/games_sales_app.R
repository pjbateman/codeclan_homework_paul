library("tidyverse")
library("shiny")
games_sales <- CodeClanData::game_sales


# ui ----------------------------------------------------------------------
ui <- fluidPage(
  
  titlePanel(tags$h1("Critics Scores vs. User Scores")),
  
  sidebarLayout(
    sidebarPanel(
      
      radioButtons("genre",
                   "Genre?",
                   choices = sort(unique(game_sales$genre))
      ),
      
      sliderInput("slider1", label = h3("Year of release"), min = 1988, 
                  max = 2016, value = 1999)
    ),
    
    mainPanel(
      plotOutput("scatter_plot") # idea was to allow the user to assess the relationship between critic and user score, and see if there was "agreement" in certain genres or years
    )
  )
)





# server ------------------------------------------------------------------


server <- function(input, output) {
  
  output$value <- renderPrint({ input$slider1 })
  
  output$scatter_plot <- renderPlot({
    
    game_sales %>% 
      filter(year_of_release == input$slider1) %>% 
      filter(genre == input$genre) %>% 
      mutate(user_score_new = user_score * 10) %>% 
      ggplot() +
      aes(x = critic_score, y = user_score_new) +
      geom_point()
  })
}


# shiny_app ---------------------------------------------------------------


shinyApp(ui = ui, server = server)