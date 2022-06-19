# Product - Adds product with code, name & price

class Product
  attr_reader :code, :price

  def initialize(code, name, price)
    @code = code
    @price = price
    @name = name
  end

end