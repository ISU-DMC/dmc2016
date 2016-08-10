############### Logistic Regression with LASSO Penalty ###############
library(glmnet)

train <- read.table("train.csv", header = TRUE, sep = ",")
test <- read.table("test.csv", header = TRUE, sep = ",")
class <- read.table("class.csv", header = TRUE, sep = ",")

train[is.na(train)] <- 0
test[is.na(test)] <- 0
class[is.na(class)] <- 0
train$returnQuantity[train$returnQuantity > 1] <- 1


opt.lambda.t <- cv.glmnet(as.matrix(train[, -1]), y = as.matrix(train$returnQuantity), family = "binomial", alpha = 1)
opt.lambda.t$lambda.min
logi.lasso.t <- glmnet(as.matrix(train[, -1]), y = as.matrix(train$returnQuantity), family = "binomial", lambda = opt.lambda.t$lambda.min, alpha = 1)
pred.link.t <- predict.glmnet(logi.lasso.t, type = "link", newx = as.matrix(test[, -1]))
pred.link.t1 <- predict(opt.lambda.t, type = "link", newx = as.matrix(test[, -1]))


pred.lasso.t <- 1 - 1 / (exp(pred.link.t) + 1)
pred.lasso.tbina <- as.numeric(pred.lasso.t >= 0.5)
pred.lasso.tbina[test$quantity == 0] = 0
print(mean(abs(pred.lasso.tbina - test[, 1])))

pred.lassot <- as.data.frame(cbind(pred.lasso.tbina, round(pred.lasso.t, digits = 4)))
colnames(pred.lassot) <- c("binary", "continuous")
write.csv(pred.lassot, file = "LiXinyi_LogisticLASSO_Test.csv", row.names = FALSE, quote = FALSE)


test$returnQuantity[test$returnQuantity > 1] <- 1

# opt.lambda.c <- cv.glmnet(as.matrix(rbind(train[, -1], test[, -1])), y = as.matrix(c(train$returnQuantity, test$returnQuantity)), family = "binomial", alpha = 1)
# opt.lambda.c$lambda.min
logi.lasso.c <- glmnet(as.matrix(rbind(train[, -1], test[, -1])), y = as.matrix(c(train$returnQuantity, test$returnQuantity)), family = "binomial", lambda = opt.lambda.t$lambda.min, alpha = 1)
pred.link.c <- predict.glmnet(logi.lasso.c, type = "link", newx = as.matrix(class))

pred.lasso.c <- 1 - 1 / (exp(pred.link.c) + 1)
pred.lasso.cbina <- as.numeric(pred.lasso.c >= 0.5)
pred.lasso.cbina[test$quantity == 0] = 0

pred.lassoc <- as.data.frame(cbind(pred.lasso.cbina, round(pred.lasso.c, digits = 4)))
colnames(pred.lassoc) <- c("binary", "continuous")
write.csv(pred.lassoc, file = "LiXinyi_LogisticLASSO_Class.csv", row.names = FALSE, quote = FALSE)