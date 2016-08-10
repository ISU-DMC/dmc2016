############### Linear Regression with LASSO Penalty ###############
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


opt.lambda.t <- cv.glmnet(as.matrix(train[, -1]), y = as.matrix(train$returnQuantity), family = "gaussian", alpha = 1)
opt.lambda.t$lambda.min
lm.lasso.t <- glmnet(as.matrix(train[, -1]), y = as.matrix(train$returnQuantity), family = "gaussian", lambda = opt.lambda.t$lambda.min, alpha = 1)
pred.lasso.t <- predict.glmnet(lm.lasso.t, type = "link", newx = as.matrix(test[, -1]))

# pred.lasso.t <- exp(pred.link.t)
pred.lasso.tbina <- as.numeric(pred.lasso.t >= 0.5)
pred.lasso.tbina[test$quantity == 0] = 0
print(mean(abs(pred.lasso.tbina - test[, 1])))

pred.lassot <- as.data.frame(cbind(pred.lasso.tbina, round(pred.lasso.t, digits = 4)))
colnames(pred.lassot) <- c("binary", "continuouts")
write.csv(pred.lassot, file = "LiXinyi_LMLASSO_Test.csv", row.names = FALSE, quote = FALSE)


# test$returnQuantity[test$returnQuantity > 1] <- 1

# opt.lambda.c <- cv.glmnet(as.matrix(train_final[, -1]), y = as.matrix(train_final$returnQuantity), family = "gaussian", alpha = 1)
# opt.lambda.c$lambda.min
lm.lasso.c <- glmnet(as.matrix(train_final[, -1]), y = as.matrix(train_final$returnQuantity), family = "gaussian", lambda = opt.lambda.t$lambda.min, alpha = 1)
pred.lasso.c <- predict.glmnet(lm.lasso.c, type = "link", newx = as.matrix(class))

# pred.lasso.c <- exp(pred.link.c)
pred.lasso.cbina <- as.numeric(pred.lasso.c >= 0.5)
pred.lasso.cbina[test$quantity == 0] = 0

pred.lassoc <- as.data.frame(cbind(pred.lasso.cbina, round(pred.lasso.c, digits = 4)))
colnames(pred.lassoc) <- c("binary", "continuous")
write.csv(pred.lassoc, file = "LiXinyi_LMLASSO_Class.csv", row.names = FALSE, quote = FALSE)