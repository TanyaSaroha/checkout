require 'json'
require_relative 'promo_type'

class Promotion
  attr_reader :rules

  def initialize(promotion_type, product_id=nil)
    @rules = promotion_type == 'item' ? get_promos_for_product(product_id) : get_total_promos
  end

  def discounted_price(price, quantity)
    applicable_rule = get_applicable_rule('min_quantity', quantity)
    applicable_rule ? apply_rule(applicable_rule, price) : price
  end

  def discounted_total(total)
    applicable_rule = get_applicable_rule('min_amount', total)
    applicable_rule ? apply_rule(applicable_rule, total) : total
  end

  private

  def get_promos_for_product(item_code)
    file = File.read('src/promotions.json')
    data_hash = JSON.parse(file)
    rule = data_hash["items"].detect { |k, _| k == item_code }
    rule ? rule[1] : nil
  end

  def get_total_promos
    file = File.read('src/promotions.json')
    data_hash = JSON.parse(file)
    data_hash["total"]
  end

  def calculate_percentage_price(total, discount)
    discount = (total / 100 * discount)
    (total - discount).round(2)
  end

  def get_applicable_rule(sort_param, comparator)
    applicable_rule = {}
    @rules = @rules.sort_by { |hsh| hsh[sort_param] }.reverse
    @rules.each{ |rule| applicable_rule = rule and break if rule[sort_param] <= comparator }
    applicable_rule.any? ? applicable_rule : nil
  end

  def apply_rule(applicable_rule, price)
    applicable_rule["type"] == PromoType::AMOUNT ? price - applicable_rule['discount'] : (applicable_rule["type"] == PromoType::PERCENT ? calculate_percentage_price(price, applicable_rule['discount']) : price)
  end

end
