#! /usr/bin/env perl

use strict;
use warnings;

my $orderID;
my $orderDate;
my $articleID;
my $colorCode;
my $sizeCode;
my $productGroup;
my $quantity;
my $price;
my $rrp;
my $voucherID;
my $voucherAmount;
my $customerID;
my $deviceID;
my $paymentMethod;
my $returnQuantity;

# Running total number of items purchased by a particular customer
my %totalItems;

# Running total number of purchase orders by a particular customer
my %totalOrders;
my $previousOrderID="";

# Running total number of vouchers used
my %totalVoucher;

# Running total value of vouchers used
my %totalVoucherAmount;

# header
print "runningTotalItems,runningTotalOrders,runningTotalVoucherAmount\n";
while(<>){
    chomp;

    # split into named variables for readability
    # @item=split... would be faster
    ($orderID,$orderDate,$articleID,$colorCode,$sizeCode,
     $productGroup,$quantity,$price,$rrp,$voucherID,
     $voucherAmount,$customerID,$deviceID,$paymentMethod,
     $returnQuantity)=split(/;/,$_); 

    if(/^a/){
	$totalItems{$customerID}++;	

	if(!($orderID eq $previousOrderID)){
	    $totalOrders{$customerID}++;
	    $totalVoucherAmount{$customerID}+=$voucherAmount;
	}
	print "$totalItems{$customerID},$totalOrders{$customerID},$totalVoucherAmount{$customerID}\n";
	
	$previousOrderID=$orderID;
    }
}
