shinyUI(
  fluidPage(
    titlePanel("Test App Utrecht"),
    fluidRow(
      column(3, wellPanel(
        helpText("Vul A en B in om de vorm van de verdeling aan te passen"),
        textInput("a", "Please select A", 2),
        textInput("b", "Please select B", 2),  
        helpText("Verplaats de schuifjes hieronder om de kans aan te geven, met de onder en bovengrens"),
        sliderInput("control_num","Kans:",min = 0, max = 1, value = .5, step=.05),
        uiOutput("lower"),
        uiOutput("higher"),
        actionButton("submit", "Verstuur resultaten!"))),
       
      column(3, mainPanel(
        plotOutput("myPlot", height = 350, width = 550))
      )
    )
  )
)


