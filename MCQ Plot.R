# library(corrplot)
# library(tidyr)
library(irtoys)
# library(jsonlite)

code <- read.csv("answers.csv") # read raw answers from file 
key <- read.csv("answer key.csv") # read answer key 
n <-dim(code)[1] # number of examinees
m <-dim(code)[2] # number of items

score <- (code==matrix(rep(key,each=n),ncol=m))+0
hist(colMeans(score)) # histogram of items' performance
hist(rowMeans(score)) # histogram of candidates' achievement
ts <- rowSums(score)
# function descript provides perc. of correct answers 
# and coef. of discrimination 
dsc <- descript(score)
# p, r & NA
p <- dsc$perc[,2] # number of correct answers
r <- dsc$ExBisCorr # biserial correlation with exclusion
na <- colMeans(code=="") # ratio of unanswered items
# alternatives' characteristic curves
dx <- .1 # interval for quantiles
for (i in 1:m) {
  tsi <- rowSums(score[,-i]) # total score for all examinees
  ptsr <- seq(0,1,dx) # intervals for grouping
  q <- quantile(tsi,ptsr) # quantiles
  cts <- cut(tsi,q) # grouping results for each interval
  x <- ptsr[-11]+diff(ptsr)/2 # quantiles for x-axis 
  # frequences of alternatives
  icA <- tapply(code[,i]=="A",cts,mean)
  icB <- tapply(code[,i]=="B",cts,mean)
  icC <- tapply(code[,i]=="C",cts,mean)
  icD <- tapply(code[,i]=="D",cts,mean)
  icE <- tapply(code[,i]=="E",cts,mean)
  icNA <- tapply(code[,i]=="",cts,mean)
  file <- paste0("Item_",i,".png")
  png(file,width=800,height=800,pointsize=20)
  plot(x,icA,xlab="Quantile",ylab="Performance",
       type="b",pch=21,bg=2,col=1,ylim=c(0,1),xlim=c(0,1))
  lines(x,icB,type="b",pch=22,bg=3)
  lines(x,icC,type="b",pch=23,bg=4)
  lines(x,icD,type="b",pch=24,bg=5)
  lines(x,icE,type="b",pch=25,bg=6)
  grid()
  txt <- paste0("Item ",i,":  p=",round(p[i],2),"  r=",round(r[i],2),"  na=",round(na[i],2))
  text(.30,1,txt)
  legend(0,0.9, c("A","B","C","D","E"), cex=.8, pch = c(21,22,23,24,25),
         pt.bg=(2:6)*(c("A","B","C","D","E")==key[i]),
         box.col="gray")
  dev.off()
}
