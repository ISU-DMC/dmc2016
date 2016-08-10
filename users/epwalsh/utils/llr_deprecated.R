# Code to compute estimated log-likelihood ratios for categorical 
# variables and binary response. The second function is to calculate the 
# log-likelihood ratios for an interaction between two categorical variables.
# This is based on the work by Cory Lanker.

compute_ll <- function(x, y, targetX, epsilon1 = NULL, epsilon2 = NULL)  {
  # x A character vector
  # y A numeric vector of 0's and 1's
  # targetX A character vector with the same categories as x
  # Takes a categorical predictor variable, x, and a binary response
  # variable, y, and produces a vector of the estimated log-likelihood
  # statistics for the targetX column. An epsilon > 0 is added to the numerator 
  # and denominator to prevent numerical instability.
  # Non-matching categories will result in NA entries
  stopifnot(all(y %in% c(0,1))) # response has to be binary
  if (is.null(epsilon1) | is.null(epsilon2)) {
    epsilon1 = mean(y)
    epsilon2 = 1 - epsilon1
  }
  levs <- unique(x)
  # This will create a vector of the estimated log-likelihood ratios for
  # each level of the explanatory variable. 
  lls <- sapply(levs, FUN = function(levs) {
                  log((sum(x == levs & y == 1) + epsilon1) / 
                      (sum(x == levs & y == 0) + epsilon2))
                })
  res <- lls[targetX]
  names(res) <- targetX
  res[is.na(res)] <- log(epsilon1 / epsilon2)
  return(res)
}

# Testing code
# --------------------------------------------------
x <- sample(c("red", "blue"), 10, replace = T)
y <- rbinom(10, 1, 0.7)
targetX <- sample(c("red", "blue"), 15, replace = T)
targetX[10] <- "green"
data.frame(targetX, compute_ll(x, y, targetX))
# --------------------------------------------------


compute_ll_2w <- function(x1, x2, y, targetX1, targetX2, 
                          epsilon1 = NULL,
                          epsilon2 = NULL) {
  # x1 A character vector
  # x2 A character vector
  # y A numeric vector of 0's and 1's
  # targetX1 A character vector with the same categories as x1
  # targetX2 A character vector with the same categories as x2
  # Takes 2 categorical predictor variables, x1 and x2, and a binary response
  # variable, y, and produces a vector of the estimated log-likelihood
  # statistics for all combinations between the levels of each predictor for
  # targetX1 and targetX2.
  # An epsilon > 0 is added to the numerator and denominator to prevent 
  # numerical instability.
  # Non-matching categories will result in NA entries
  stopifnot(all(y %in% c(0,1))) # response has to be binary
  if (is.null(epsilon1) | is.null(epsilon2)) {
    epsilon1 = mean(y)
    epsilon2 = 1 - epsilon1
  }
  levs_1 <- unique(x1)
  levs_2 <- unique(x2)
  # Using sapply within sapply will create a matrix. This will create a matrix 
  # of the estimated log-likelihood ratios for each unique combination of the 
  # levels of each explanatory variable.
  lls <- sapply(levs_2, FUN = function(levs_2) {
                  sapply(levs_1, FUN = function(levs_1) {
                           log((sum(x1 == levs_1 & x2 == levs_2 & y == 1) + epsilon1) / 
                               (sum(x1 == levs_1 & x2 == levs_2 & y == 0) + epsilon2))
                         })
                })
  index <- 1:length(targetX1)
  res <- sapply(index, FUN = function(index) {
                  if (targetX1[index] %in% rownames(lls) & 
                      targetX2[index] %in% colnames(lls)) {
                    lls[targetX1[index], targetX2[index]]
                  } else {
                    NA
                  }
                })
  res[is.na(res)] <- log(epsilon1 / epsilon2)
  return(res)
}

# Testing code
# --------------------------------------------------
x1 <- sample(c("red", "blue"), 10, replace = T)
x2 <- sample(c("square", "triangle"), 10, replace = T)
y <- rbinom(10, 1, 0.5)
targetX1 <- sample(c("red", "blue"), 15, replace = T)
targetX2 <- sample(c("square", "triangle"), 15, replace = T)
data.frame(targetX1, targetX2, compute_ll_2w(x1, x2, y, targetX1, targetX2))
# --------------------------------------------------

# Demonstrate usage on real data
# s1 <- readRDS("~/GitHub/dmc2015/data/featureMatrix/HTVset1.rds")
# d <- data.frame(orderID = rep(s1$H$orderID, 3),
#                 brand = c(as.character(s1$H$brand1), 
#                           as.character(s1$H$brand2), 
#                           as.character(s1$H$brand3)),
#                 reward = c(as.character(s1$H$reward1),
#                            as.character(s1$H$reward2),
#                            as.character(s1$H$reward3)),
#                 coupUsed = c(s1$H$coupon1Used, s1$H$coupon2Used, s1$H$coupon3Used),
#                 stringsAsFactors = F)
# d <- d[order(d$orderID),]
# 
# s1$T$brand_rew_1 <- compute_ll_2w(d$brand, d$reward, d$coupUsed,
#                                  as.character(s1$T$brand1),
#                                  as.character(s1$T$reward1))
