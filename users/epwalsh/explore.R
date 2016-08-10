# =============================================================================
# File Name:     01_explore.R
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 06-04-2016
# Last Modified: Fri Apr 15 15:20:03 2016
# =============================================================================

library(dplyr)
library(readr)

data_path  <- "~/ISU-DMC/dmc2016/data/raw_data/orders_train.txt"

# This is going to complain a lot, probably about missing data. Just ignore.
dat <- read_delim(data_path, ';')
str(dat)

dat %>% group_by(articleID, sizeCode) %>%
  summarize(n = length(returnQuantity))

dat %>% group_by(articleID, colorCode) %>%
  summarize(n = length(returnQuantity))

# Customers {{{
# Get number of unique orders by customerID
cust <- dat %>% group_by(customerID) %>%
  summarize(n_orders = length(unique(orderID)),
            returnRate = mean(returnQuantity))

max(cust$n_orders)  # 365

# This one dickhead returned almost everything
x <- cust$customerID[which.max(cust$returnRate)]
dat[dat$customerID == x,]$returnQuantity
# >> Bought 10 things, same articleID, 5 in two different sizes. Returned all
# but one.
# }}}

temp <- dat[dat$customerID == 'c1000001',]
temp$customerID

head(dat)
