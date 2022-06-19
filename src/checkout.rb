require_relative 'promotion'

# Checkout - Scan Items and generate total
class Checkout

  def initialize
    @items = [] #Products being bought
  end

  # If some product is already in item list increase the quantity by 1, otherwise add in item list
  def scan(product)
    existing_item = find_item_by_code(product.code)
    existing_item ? existing_item[:quantity] += 1 : @items << { info: product, quantity: 1 }
  end

  # Calculate total
  def total(promotion_name = false)
    total = 0
    @items.each{ |item| total = final_price_for_item(item, total) } #checking discount on each item in the list
    discount_on_total(total) #checking discount on total
  end

  private

  # Check if Product is already present in item list
  def find_item_by_code(code)
    return unless @items.any?
    @items.detect { |item| item[:info].code == code }
  end

  # Check if Product is already present in item list
  def final_price_for_item(item, total)
    price = item[:info].price
    @promo = Promotion.new('item', item[:info].code) #Gets promotional rules for given product
    price = @promo.discount_on_item(price, item[:quantity]) if @promo.rules #Applying promotional rules if any
    total + price * item[:quantity] # Updating total by adding price after discount
  end

  def discount_on_total(total)
    @promo = Promotion.new('total')  #Gets promotional rules on total
    @promo.rules ? @promo.discount_on_total(total) : total
  end
end
