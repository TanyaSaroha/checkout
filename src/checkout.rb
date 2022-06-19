require_relative 'promotion'

class Checkout

  def initialize
    @items = []
  end

  def scan(product)
    existing_item = find_item_by_code(product.code)
    existing_item ? existing_item[:quantity] += 1 : @items << { info: product, quantity: 1 }
  end

  def find_item_by_code(code)
    return unless @items.any?
    @items.detect { |item| item[:info].code == code }
  end

  def total(promotion_name = false)
    total = 0
    @items.each{ |item| total = sum_item(item, total) }
    discounted_total total
  end

  private

  def sum_item(item, total)
    price = item[:info].price
    @promo = Promotion.new('item', item[:info].code)
    price = @promo.discounted_price(price, item[:quantity]) if @promo.rules
    total + price * item[:quantity]
  end

  def discounted_total(total)
    @promo = Promotion.new('total')  
    @promo.rules ? @promo.discounted_total(total) : total
  end
end
