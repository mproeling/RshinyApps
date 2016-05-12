shinyUI(
  fluidPage(
    titlePanel("Test App Utrecht"),
    fluidRow(
      column(3, wellPanel(
        helpText("Hoeveel procent van de onderzoekers pleegt fraude?"),
        sliderInput("percentage","Percentage:",min = 0, max = 100, value = 50, step=.5),
        uiOutput("onzekerheid"),
        actionButton("submit", "Verstuur resultaten!"))),
      column(3, mainPanel(
        plotOutput("myPlot", height = 350, width = 550))
      )
    )
  )
)


