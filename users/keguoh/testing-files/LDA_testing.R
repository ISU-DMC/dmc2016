trn <- read.table("train.csv", header = T, sep = ",")
tst <- read.table("test.csv", header = T, sep = ",")
trn$returnQuantity <- as.numeric(trn$returnQuantity > 0)

all_dat <- rbind(trn, tst)

# Removing the constant variables
train_names <- names(trn)[-1]
for (i in train_names)
{
  if (class(all_dat[[i]]) == "integer") 
  {
    u <- unique(all_dat[[i]])
    if (length(u) == 1) 
    {
      all_dat[[i]] <- NULL
    } 
  }
}

#Removing duplicate columns
train_names <- names(all_dat)[-1]
fac <- data.frame(fac = integer())    

for(i in 1:length(train_names))
{
  if(i != length(train_names))
  {
    for (k in (i+1):length(train_names)) 
    {
      if(identical(all_dat[,i], all_dat[,k]) == TRUE) 
      {
        fac <- rbind(fac, data.frame(fac = k))
      }
    }
  }
}
same <- unique(fac$fac)
all_dat <- all_dat[,-same]
# Splitting the data for model
train <- all_dat[1:nrow(trn), ]
test <- all_dat[-(1:nrow(trn)), ]


library(MASS)
lda.fit=lda(returnQuantity~.,data=trn[, -19])

lda.fit
plot(lda.fit)
lda.pred=predict(lda.fit, tst[,-19])
names(lda.pred)
lda.class=lda.pred$class
table(lda.class,Direction.2005)
mean(lda.class==Direction.2005)
sum(lda.pred$posterior[,1]>=.5)
sum(lda.pred$posterior[,1]<.5)
lda.pred$posterior[1:20,1]
lda.class[1:20]
sum(lda.pred$posterior[,1]>.9)
