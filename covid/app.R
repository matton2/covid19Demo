

library(shiny)
library(tidyverse)


covidData <- read_csv("https://raw.githubusercontent.com/RamiKrispin/coronavirus-csv/master/coronavirus_dataset.csv")
popData <- read_csv("https://datahub.io/JohnSnowLabs/population-figures-by-country/r/population-figures-by-country-csv.csv") %>% 
    select(Country, Year_2016) %>% 
    mutate(Country = if_else(Country=="United States", "US", Country))

covidPop <- covidData %>% 
    left_join(popData, by = c("Country.Region" = "Country")) %>% 
    group_by(date, Country.Region) %>%
    mutate(totalCases = cumsum(cases),
           cases.pop = (totalCases/1000)/(Year_2016/1000000))

ggplot(filter(covidPop, Country.Region %in% c("US", "Italy")), aes(x = date, y = cases.pop, color = type)) +
    geom_point() +
    geom_line(aes(linetype = Country.Region))


# Define UI for application that draws a histogram
ui <- navbarPage(
    title = "Scrap Covid Data",
    tabPanel(
        'Home',
        h2("Home Page"),
        p("This page will scrap data from two sources to generate a covid web page"),
        
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {


}

# Run the application 
shinyApp(ui = ui, server = server)
