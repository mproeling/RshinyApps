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
    
a=10
b=10
  
x <- seq(0, 1, length = 1025)
f.out=pl.beta(a,b)

matplot(x, f.out, type="l", ylim=c(0,max(f.out)),
        main = sprintf("Kans op fraude"),
        xlab="Probability", ylab="")