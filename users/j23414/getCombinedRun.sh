#! /usr/bin/env bash

cat orders_train.txt orders_class.txt | ./getRunningTotals.pl > combined.txt
head -n 2325166 combined.txt > j23414_runningTotals_train.csv
echo "runningTotalItems,runningTotalOrders,runningTotalVoucherAmount" > j23414_runningTotals_class.csv
tail -n 341098 combined.txt >>j23414_runningTotals_class.csv