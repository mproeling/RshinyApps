shinyServer(
  function(input, output, session){
    output$myPlot <- renderPlot({
      
      ## function to calculate dbeta
      pl.beta <- function(a,b, asp = if(isLim) 1, ylim = if(isLim) c(0,1.1)) {
        
        if(isLim <- a == 0 || b == 0 || a == Inf || b == Inf) {
          eps <- 1e-10
          x <- c(0, eps, (1:7)/16, 1/2+c(-eps,0,eps), (9:15)/16, 1-eps, 1)
        } else {
          x <- seq(0, 1, length = 1025)
        }
        
        f <- dbeta(x, a,b)
        f[f == Inf] <- 1e100
        return(f)
      }
      
      # input parameters to determine shape of distribution
      a=as.numeric(input$a)
      b=as.numeric(input$b)
      
      # get output from sequence (x should be identical to x in function) and dbeta
      x <- seq(0, 1, length = 1025)
      f.out=pl.beta(a,b)
      
      # plot
      output$myPlot <- renderPlot({
        
        matplot(x, f.out, ylab="", type="l", ylim=c(0,max(f.out)),
                main = sprintf("dbeta(A=%g, B=%g)", a,b),
                xlab="Probability")
                abline(v=as.numeric(input$control_num), col="red", lwd=2)
                abline(v=as.numeric(input$inputprob_l), col="orange", lty=3)
                abline(v=as.numeric(input$inputprob_h), col="orange", lty=3)
                text(as.numeric(input$control_num)+0.05,1.2,"Kans", col="red")
                text(as.numeric(input$inputprob_l)-0.01,0.5,"Ondergrens", srt=270, col="orange")
                text(as.numeric(input$inputprob_h)+0.02,0.5,"Bovengrens", srt=270, col="orange")                
                })

      observe({
        updateSliderInput(session, "inputprob_l", value=input$control_num-.05)
        updateSliderInput(session, "inputprob_h", value=input$control_num+.05)
      })
 
    })
  
  }
  
  )
