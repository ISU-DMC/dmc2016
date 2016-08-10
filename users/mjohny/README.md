## Personal space for mjohny

Add the names of any files you don't want to commit to the ```.gitignore``` file in this directory.

###Ideas 
* within one order, rank the items by price. Is there relationship between price ranking within order and return?
* there may be relationship between price ranking and voucher. For example, some % off coupons can only be applied to least expensive item. Is this the case here?

###Findings 
####Voucher Amount
* Only one voucher ID per order. The voucher then gets applied to the items in the order.  => Prob need to group orders together to study effect of voucherID
* Maybe some vouchers can only be applied to certain product groups. How to check this?

####Weird rrp stuff 
* rrp is likely per quantity
* price per item is almost always less than or equal to rrp
*   exception: there are some orders of quantity 1 where price>rrp. These have the same 7 articleIDs

* price_unit = price/quantity
* there is positive relationship between proportion of rrp paid and mean return. 

####Relationship between quantity and returnQuantity
* mean number of returned items per order is highest for orders of quantity = 2
* quantity = 3,4,5 have similar mean number of returned items per order 

####Relationship between size and product group
* certian products only come in certain sizes. could indicate what kind of product it is.

####Relationship between size and return ratio
* return ratio is defined as (sum returned items) / (sum quantity items bought)
* people less likely to return items of size A => accessory? 
* people tend to like to return size XL items.



