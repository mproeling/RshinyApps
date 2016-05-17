shinyUI(
  fluidPage(
    titlePanel("Fraud detectie performance calculator"),
    fluidRow(
      
      column(4, wellPanel(
        helpText("Wat is de kans dat een random medewerker / klant fraude pleegt? / Hoe vaak komt fraude voor in de organisatie?"),
        numericInput('prevalence', 'Kans in procenten (0.1 = 0.1% = 1 op 1000)', 0.1, min = 0, max = 100, step = 0.0001),
        
        helpText("Als er fraude wordt gepleegd, de kans dat het detectie systeem een alert geeft."),
        sliderInput("ppv","Kans in procenten:",min = 50, max = 100, value = 90, step=.5),

        helpText("Als het detectie systeem aangeeft dat het fraude is, hoe vaak is de classificatie dan incorrect (dwz vals positief)?"),
        sliderInput("type1","Kans in procenten:",min = 0, max = 50, value = 8, step=.5))
      ),

      column(3, mainPanel(
        plotOutput("myPlot", height = 550, width = 750),
        textOutput("text1"),
        verbatimTextOutput("textarea.out"), width = 50)
      )
    )
  )
)
