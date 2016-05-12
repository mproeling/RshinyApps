shinyUI(
  pageWithSidebar(
    headerPanel("Test App Utrecht"
    ),
  
    sidebarPanel(
      textInput("a", "Please select a", 2),
      textInput("b", "Please select b", 2),  
      sliderInput("prob", "Please select probability",
                  min=0, max=1, value=0.5, step=0.05),
      sliderInput("lower", "Please select upper bound",
                  min=0, max=1, value=0.45, step=0.05),
      sliderInput("higher", "Please select higher bound",
                  min=0, max=1, value=0.55, step=0.05)
    ),
   
    mainPanel(          
      plotOutput("myPlot", height = 350, width = 550)
    )
  )
)



