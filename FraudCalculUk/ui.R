shinyUI(
  fluidPage(
    titlePanel("Fraud detection performance calculator"),
    fluidRow(
      
      column(4, wellPanel(
        helpText("What is the chance that a random employee or customer will commit fraud / How often does fraud occur in the organisation?"),
        numericInput('prevalence', 'Chance in percentage (0.1 = 0.1% = 1 op 1000):', 0.1, min = 0, max = 100, step = 0.0001),
        
        helpText("If it is fraud, what is the chance that the detection system will provide an alert?"),
        sliderInput("ppv","Chance in percentage:",min = 50, max = 100, value = 90, step=.5),

        helpText("Upon an alert of the system, how often will the classification be incorrect (false positive)?"),
        sliderInput("type1","Chance in percentage:",min = 0, max = 50, value = 8, step=.5))
      ),

      column(3, mainPanel(
        plotOutput("myPlot", height = 550, width = 750),
        textOutput("text1"),
        verbatimTextOutput("textarea.out"), width = 50)
      )
    )
  )
)
