# Problem Statement


For an online marketplace, here is a sample of some of the products available:

```
Product code | Name                  | Price
-------------|-----------------------|---------------------
001          | Silver Earrings       | £9.25
002          | Dove Dress in Bamboo  | £45.00
003          | Autumn Floral Shirt   | £19.95
```

The marketing team want to offer promotions as an incentive for our customers to purchase these items.

If you spend over £60, then you get 10% off your purchase
If you buy 2 or more sets of earrings then the price drops to £8.50.

Our check-out can scan items in any order, and because our promotions will change, it needs to be flexible regarding our promotional rules.

The interface to our checkout looks like this (shown in Ruby):

```
co = Checkout.new(promotional_rules)
co.scan(item)
co.scan(item)
price = co.total
Implement a checkout system that fulfills these requirements.
```

```
Test data
---------
Basket: 001,002,003
Total price expected: £66.78
Basket: 001,003,001
Total price expected: £36.95
Basket: 001,002,001,003
Total price expected: £73.76
```


### Proposed Solution in Ruby

#### Running Locally
- Clone the repo
- Command to run  
```
    ruby src/app.rb
```
  - This command will use run program for all three test cases given in problem statement and print output.
#### Promotional Rule or Discount
- It can be on items.
- It can be the total bill.
- It can be in percentage or a fixed amount.
- Multiple promotions can be present.
- If two or more promotions present for the same item or on total, only one will be applied. Example:
    - if more than 1 earrings are bought, price drops to 8.50
    - if more than 3 or more earrings are bought, price drops to 8.25
    - If someone buys 4 earrings then only second rule will apply.

#### Assumptions
- Promotions will come in JSON format from an API call.
- Currently, I have added a JSON file which contains promotions in JSON format.
- It jsonn be updates to add or remove promos.

#### Flow:
- For every checkout, create a new instance of checkout class.
- For each checkout we have a list of items. (Objects of Item Class) 
- We scan items one by one in random order to add them to item list. Same item can be scanned multiple times.
- Once we are done adding items, we can get total which is calculated by checking the promotions available.
