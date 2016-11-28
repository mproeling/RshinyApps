library(shiny)
library(rdrop2)

token <- drop_auth()
saveRDS(token, "droptoken.rds")

# ******** WARNING ********
# Losing this file will give anyone complete control of your Dropbox account
# You can then revoke the rdrop2 app from your dropbox account and start over.
# ******** WARNING ********

# read it back with readRDS
token <- readRDS("droptoken.rds")
drop_acc(dtoken = token)

save_data_dropbox <- function(data) {
  data <- t(data)
  file_name <- paste0(paste("person",nummer=sample(1:10000,1), format(Sys.time(), "%Y_%m_%d_%H_%M_%S") ,sep="_"),".txt")
  file_path <- file.path(tempdir(), file_name)
  write.table(data ,file_path, row.names = FALSE, quote = FALSE, col.names=F, sep=",")
  drop_upload(file_path, dest = "testutrecht")
}

shinyServer(function(input, output, session){
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
          
      # plot
      output$myPlot <- renderPlot({
        
        # input parameters to determine shape of distribution
        a=as.numeric(input$a)
        b=as.numeric(input$b)
        
        # get output from sequence (x should be identical to x in function) and dbeta
        x <- seq(0, 1, length = 1025)
        f.out=pl.beta(a,b)
        
        
        matplot(x, f.out, type="l", ylim=c(0,max(f.out)),
                main = sprintf("dbeta(A=%g, B=%g)", a,b),
                xlab="Probability", ylab="")
                abline(v=as.numeric(input$control_num), col="red", lwd=2)
                abline(v=as.numeric(input$lower), col="orange", lty=3)
                abline(v=as.numeric(input$higher), col="orange", lty=3)
                
                text(as.numeric(input$control_num)+0.05,1,"Kans", col="red")
                text(as.numeric(input$lower)-0.01,0.5,"Ondergrens", srt=270, col="orange")
                text(as.numeric(input$higher)+0.02,0.5,"Bovengrens", srt=270, col="orange")                
                })

      observe({
        updateSliderInput(session, "inputprob_l", value=input$control_num-.05)
        updateSliderInput(session, "inputprob_h", value=input$control_num+.05)

        if(is.null(input$send) || input$send==0) return(NULL)
        from <- isolate("testsender")
        to <- isolate("email")
        subject <- isolate("score")
        msg <- isolate(input$control_num)
        sendmail(from, to, subject, msg)
      })
      
      #make dynamic slider 1
      output$lower <- renderUI({
        sliderInput("lower", "Lowergrens", min=0, max=input$control_num-0.05, value=0, step=.05)
      })
      #make dynamic slider 2
      output$higher <- renderUI({
        sliderInput("higher", "Bovengrens", min=input$control_num+.05, max=1, value=1, step=.05)
      })
      
      #submit to dropbox
      observeEvent(input$submit, {
        save_data_dropbox(c(input$control_num,input$lower,input$higher))
       })    
      
    })
  }
)
