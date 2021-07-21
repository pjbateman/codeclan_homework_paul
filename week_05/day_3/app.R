
library(shiny)
library(shinythemes)
library(tidyverse)

olympics_overall_medals <- read_csv("data/olympics_overall_medals.csv")

# ui ----------------------------------------------------------------------


ui <- fluidPage(
    
    titlePanel(tags$b("Five Country Medal Comparison")),
    
    theme = shinytheme("sandstone"),
    
    fluidRow(
        
        tabsetPanel(
            tabPanel(
                "Plot",
                plotOutput("medal_plot")
                    ,
            column(
                6,
                radioButtons("season_input",
                             tags$i("Summer or Winter Olympics?"),
                             choices = c("Summer", "Winter")
                            )
                    ),
            column(
                6,
                radioButtons("medal_input",
                             tags$i("Compare Which Medals?"),
                             choices = c("Gold", "Silver", "Bronze")
                            )
                )
            ),
         tabPanel(
                "Website",
                tags$a("Olympic website", href = "https://olympic.org/")
                    ),
         tabPanel("Third Tab",
                  "Third Tab Content goes here"
         )
                )
                    )
)

# server ------------------------------------------------------------------


server <- function(input, output) {
    output$medal_plot <- renderPlot({
        
        olympics_overall_medals %>%
            filter(team %in% c(
                "United States",
                "Soviet Union",
                "Germany",
                "Italy",
                "Great Britain"
            )) %>%
            filter(medal == input$medal_input) %>%
            filter(season == input$season_input) %>%
            ggplot() +
            aes(x = team, y = count, fill = medal) +
            geom_col() +
            scale_fill_manual(values = c("Gold" = "#D4AF37",
                                         "Silver" = "#C0C0C0",
                                         "Bronze" = "#B08D57"))
    })
}

# shiny_app ---------------------------------------------------------------


shinyApp(ui = ui, server = server)