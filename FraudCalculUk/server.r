shinyServer(function(input, output,session){
    
    # function to perform calculation
    bayesrule <- function(x,y,z){
    # x = prevalence y = ppv z = type1
    Pr.plus = (x * y) + ((1-x) * z)
    correct = (x * y) / Pr.plus
    return(correct)  
    }
  
    bs <- reactive({
      result <- bayesrule(input$prevalence/100, input$ppv/100, input$type1/100)
      result_p <- round(result*100,2)
      return(result_p)
    })

    # function to make the plot
    output$myPlot <- renderPlot({

      # plot
      output$myPlot <- renderPlot({
        
      # create data
      Nred = ceiling((input$prevalence/100)*10000)
      df <- data.frame(x = rnorm(10000),y = rnorm(10000), c(rep("black",10000-Nred),rep("red",Nred)))
      with(df, plot(x, y, main = "Density", col=df[,3]))
      })
    })
    
    # Creating the feedback text
    output$text1 <- renderText({ 
      paste("The chance of an alert really being fraudulent:")
    })
    
    output$textarea.out <- renderText({
      paste(bs(),"%")
    })
    
  }
)
