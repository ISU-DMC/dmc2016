
train_raw = read.csv(file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/orders_train.csv")
test_raw = read.csv(file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/orders_test.csv")

new_productGroup_test = read.csv(file = "/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/binned_new_productGroup/binned_new_productGroup_test.csv")
new_productGroup_train = read.csv(file = "/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/binned_new_productGroup/binned_new_productGroup_train.csv")

train_raw$article_t_h <- substr(train_raw$articleID,5,6)
test_raw$article_t_h <- substr(test_raw$articleID,5,6)

train_raw$binned_productGroup_article_t_h<- paste(new_productGroup_train$binned_new_productGroup_option_1, train_raw$article_t_h, sep="")
test_raw$binned_productGroup_article_t_h<- paste(new_productGroup_test$binned_new_productGroup_option_1, test_raw$article_t_h, sep="")

write.table(train_raw$binned_productGroup_article_t_h, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/binned_productGroup_article_t_h_in_train_raw.csv", row.names = FALSE,col.names = F)
write.table(test_raw$binned_productGroup_article_t_h, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/binned_productGroup_article_t_h_in_test_raw.csv", row.names = FALSE,col.names = F)













