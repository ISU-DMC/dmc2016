imp1 <- read.table("keguoh_C50_hanye_V1.csv", header = T, sep = ",")
imp2 <- read.table("keguoh_C50_hanye_V2.csv", header = T, sep = ",")
imp3 <- read.table("keguoh_C50_hanye_V3.csv", header = T, sep = ",")

ftr1_pst <- as.character(imp1$Features[imp1$splits>0])
ftr2_pst <- as.character(imp2$Features[imp2$splits>0])
ftr3_pst <- as.character(imp3$Features[imp3$splits>0])

sum(ftr1_pst %in% ftr2_pst)
sum(ftr1_pst %in% ftr3_pst)
sum(ftr2_pst %in% ftr3_pst)



### v2-v1
imptree <- read.table("ranks_fuzz_20.csv", header = T, sep = ",")
imprule <- read.table("ranks_Rule_fuzz_20.csv", header = T, sep = ",")
ftrtree_pst <- as.character(imptree$Features[imptree$splits>0])
ftrrule_pst <- as.character(imprule$Features[imprule$splits>0])
sum(ftrtree_pst %in% ftrrule_pst)

ftrtree_2 <- as.character(imptree$Features[1:200])
ftrrule_2 <- as.character(imprule$Features[1:200])
sum(ftrtree_2 %in% ftrrule_2)
ftrtree_2 %in% ftrrule_2

imptree <- data.frame(splits = scale(imptree$splits), row.names = imptree$Features)
imprule <- data.frame(splits = scale(imprule$splits), row.names = imprule$Features)
imp_x<-apply(rbind(t(imptree),t(imprule)), 2, mean)
write.csv(data.frame(Features = names(imp_x), Stand_Score = imp_x), row.names = F, file = "keguoh_C50_hanye_V2_select_V1.csv")


## v -v2
imp1_2 <- read.table("keguoh_C50_hanye_V1_select_V2.csv", header = T, sep = ",")
imp2_2 <- read.table("keguoh_C50_hanye_V2_select_V2.csv", header = T, sep = ",")
imp6_2 <- read.table("keguoh_C50_hanye_V6_select_V2.csv", header = T, sep = ",")
imp7_2 <- read.table("keguoh_C50_hanye_V7_select_V2.csv", header = T, sep = ",")


