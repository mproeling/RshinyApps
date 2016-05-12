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
        first_a=as.numeric(input$percentage)
        if(first_a<=0){
          a=as.numeric(input$percentage)+.01
        } else {
          a=as.numeric(input$percentage)
        }
        
        if(first_a==100){
        b=100.01-as.numeric(input$percentage)
        } else {
        b=100-as.numeric(input$percentage)
        }
        
        # get output from sequence (x should be identical to x in function) and dbeta
        x <- seq(0, 1, length = 1025)
        f.out=pl.beta(a,b)
        
        # rode lijn met probability
        Vcoor=as.numeric(input$percentage)/100 # ruw abline coordinaat
        Vcoor_cor=(.50-Vcoor)/4*-.1+Vcoor # correctie op abline coordinaat om te zorgen dat ie op het hoogste punt raakt
        
        # onzekerheidslijnen
        onz=as.numeric(input$percentage)-as.numeric(input$onzekerheid)/100
        
        
        matplot(x, f.out, type="l", ylim=c(0,max(f.out)),
                main = sprintf("Kans op fraude"),
                xlab="Probability", ylab="")
                abline(v=Vcoor_cor, col="red", lwd=2)
                abline(v=(as.numeric(input$percentage)-as.numeric(input$onzekerheid))/100, col="orange", lty=3)
                abline(v=(as.numeric(input$percentage)+as.numeric(input$onzekerheid))/100, col="orange", lty=3)
                text(as.numeric(input$percentage)/100+0.05,max(f.out),"Kans", col="red")
                text(((as.numeric(input$percentage)-as.numeric(input$onzekerheid))/100)+0.02,max(f.out)-5,"Ondergrens", srt=270, col="orange")
                text(((as.numeric(input$percentage)+as.numeric(input$onzekerheid))/100)-0.015,max(f.out)-5,"Bovengrens", srt=270, col="orange")
                })

      #make dynamic slider 1
      output$onzekerheid <- renderUI({
        #if(input$percentage<50){onz_max=input$percentage+50}else{onz_max=input$percentage} # voor variabel maximum
        sliderInput("onzekerheid", "Onzekerheid", min=0, max=50, value=5, step=.05)
      })
      
      #submit to dropbox
      observeEvent(input$submit, {
        save_data_dropbox(c(input$percentage,input$lower,input$higher))
       })
      
    })
  }
)
