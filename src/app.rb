require_relative 'checkout'
require_relative 'product'

## Adding products in our 
product1 = Product.new('001', 'Silver Earrings', 9.25)
product2 = Product.new('002', 'Dove Dress in Bamboo', 45.00)
product3 = Product.new('003', 'Autumn Floral Shirt', 19.95)

# test case 1
co = Checkout.new
co.scan(product1)
co.scan(product2)
co.scan(product3)
puts co.total

# test case 2
co = Checkout.new
co.scan(product1)
co.scan(product3)
co.scan(product1)
puts co.total

# test case 3
co = Checkout.new
co.scan(product1)
co.scan(product2)
co.scan(product1)
co.scan(product3)
puts co.total
