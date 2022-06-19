require 'json'
require_relative 'promo_type'

# Fetch and Apply Promotions
class Promotion
  attr_reader :rules

  def initialize(promotion_type, product_id=nil)
    @rules = promotion_type == 'item' ? get_promos_for_product(product_id) : get_total_promos
  end

  def discount_on_item(price, quantity)
    applicable_rule = get_applicable_rule('min_quantity', quantity) # Check if available promo is applicable
    applicable_rule ? apply_rule(applicable_rule, price) : price # Apply promo if found
  end

  def discount_on_total(total)
    applicable_rule = get_applicable_rule('min_amount', total) # Check if available promo is applicable
    applicable_rule ? apply_rule(applicable_rule, total) : total # Apply promo if found
  end

  private

  def get_promos_for_product(item_code)
    # Fetching promos and filtering for given product
    file = File.read('src/promotions.json')
    data_hash = JSON.parse(file)
    rule = data_hash["items"].detect { |k, _| k == item_code }
    rule ? rule[1] : nil
  end

  def get_total_promos
    # Fetching promos and filtering for total bill
    file = File.read('src/promotions.json')
    data_hash = JSON.parse(file)
    data_hash["total"]
  end

  # Get Applicable rule from set of available rules.
  def get_applicable_rule(sort_param, comparator)
    applicable_rule = {}
    @rules = @rules.sort_by { |hsh| hsh[sort_param] }.reverse
    @rules.each{ |rule| applicable_rule = rule and break if rule[sort_param] <= comparator }
    applicable_rule.any? ? applicable_rule : nil
  end

  # Applying the promotional rule based on type
  def apply_rule(applicable_rule, price)
    applicable_rule["type"] == PromoType::AMOUNT ? price - applicable_rule['discount'] : (applicable_rule["type"] == PromoType::PERCENT ? calculate_percentage_price(price, applicable_rule['discount']) : price)
  end

  # Subtract percentage discount amount from total price
  def calculate_percentage_price(total, discount)
    discount = (total / 100 * discount)
    (total - discount).round(2)
  end

end
