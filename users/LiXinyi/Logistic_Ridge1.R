############### Logistic Regression with Ridge Penalty ###############
library(glmnet)

train <- read.table("train.csv", header = TRUE, sep = ",")
test <- read.table("test.csv", header = TRUE, sep = ",")
class <- read.table("class_reduce.csv", header = TRUE, sep = ",")
train_final <- read.table("train_reduce.csv", header = TRUE, sep = ",") 

train[is.na(train)] <- 0
test[is.na(test)] <- 0
class[is.na(class)] <- 0
train_final[is.na(train_final)] <- 0
train$returnQuantity[train$returnQuantity > 1] <- 1
train_final$returnQuantity[train_final$returnQuantity > 1] <- 1


opt.lambda.t <- cv.glmnet(as.matrix(train[, -1]), y = as.matrix(train$returnQuantity), family = "binomial", alpha = 0)
opt.lambda.t$lambda.min
logi.ridge.t <- glmnet(as.matrix(train[, -1]), y = as.matrix(train$returnQuantity), family = "binomial", lambda = opt.lambda.t$lambda.min, alpha = 0)
pred.link.t <- predict.glmnet(logi.ridge.t, type = "link", newx = as.matrix(test[, -1]))

pred.ridge.t <- 1 - 1 / (exp(pred.link.t) + 1)
pred.ridge.tbina <- as.numeric(pred.ridge.t >= 0.5)
pred.ridge.tbina[test$quantity == 0] = 0
print(mean(abs(pred.ridge.tbina - test$returnQuantity)))

pred.ridget <- as.data.frame(cbind(pred.ridge.tbina, round(pred.ridge.t, digits = 4)))
colnames(pred.ridget) <- c("binary", "continuous")
write.csv(pred.ridget, file = "LiXinyi_LogisticRidge_Test.csv", row.names = FALSE, quote = FALSE)


# test$returnQuantity[test$returnQuantity > 1] <- 1

# opt.lambda.c <- cv.glmnet(as.matrix(train_final[, -1]), y = as.matrix(train_final$returnQuantity), family = "binomial", alpha = 0)
# opt.lambda.c$lambda.min
logi.ridge.c <- glmnet(as.matrix(train_final[, -1]), y = as.matrix(train_final$returnQuantity), family = "binomial", lambda = opt.lambda.t$lambda.min, alpha = 0)
pred.link.c <- predict.glmnet(logi.ridge.c, type = "link", newx = as.matrix(class))

pred.ridge.c <- 1 - 1 / (exp(pred.link.c) + 1)
pred.ridge.cbina <- as.numeric(pred.ridge.c >= 0.5)
pred.ridge.cbina[test$quantity == 0] = 0

pred.ridgec <- as.data.frame(cbind(pred.ridge.cbina, round(pred.ridge.c, digits = 4)))
colnames(pred.ridgec) <- c("binary", "continuous")
write.csv(pred.ridgec, file = "LiXinyi_LogisticRidge_Class.csv", row.names = FALSE, quote = FALSE)