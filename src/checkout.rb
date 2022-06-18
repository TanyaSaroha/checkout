require 'json'

require_relative 'promotion'
require_relative 'item'

class Checkout

  def initialize
    @items = []
  end

  def scan(item)
    existing_item = find_item_by_code(item.code)
    if existing_item
      existing_item[:quantity] += 1
    else
      @items << { data: item, quantity: 1 }
    end
  end

  def find_item_by_code(code)
    return unless @items.any?
    @items.detect { |item| item[:data].code == code }
  end

  def total(promotion_name = false)
    total = 0

    @items.each do |item|
      total = sum_item(item, total)
    end

    discounted_total total
  end

  private

  def sum_item(item, total)
    unit_price = item[:data].price
    @promo = Promotion.new('item', item[:data].code)    

    if @promo
      unit_price = @promo.discounted_price(
        item[:data].code,
        unit_price,
        item[:quantity]
      )
    end

    total + unit_price * item[:quantity]
  end

  def discounted_total(total)
    @promo = Promotion.new('total')  

    if @promo
      @promo.discounted_total(total)
    else
      total
    end
  end
end


## Executing
item1 = Item.new('001', 'Silver Earrings', 9.25)
item2 = Item.new('002', 'Dove Dress in Bamboo', 45.00)
item3 = Item.new('003', 'Autumn Floral Shirt', 19.95)


# test case 1
co = Checkout.new
co.scan(item1)
co.scan(item2)
co.scan(item3)
puts co.total

# test case 2
co = Checkout.new
co.scan(item1)
co.scan(item3)
co.scan(item1)
puts co.total


# test case 3
co = Checkout.new
co.scan(item1)
co.scan(item2)
co.scan(item1)
co.scan(item3)
puts co.total

