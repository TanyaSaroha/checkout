class Promotion

  def initialize(promotion_type, product_id=nil)
    @rules = promotion_type == 'item' ? get_promos_for_product(product_id) : get_total_promos
  end

  def discounted_price(item_code, price, quantity)
    return price unless @rules
    total = 0

    applicable_rule = {}

    @rules.sort_by { |hsh| hsh['min_quantity'] }.reverse!
    @rules.each do |rule|
      if rule['min_quantity'] <= quantity
        applicable_rule = rule
        break;
      end
    end

    return price unless applicable_rule.any?

    case applicable_rule["type"]
    when 'amount'
      price - applicable_rule['discount']
    when 'percentage'
      discount = (price/100 * applicable_rule['discount'])
      (price - discount).round(2)
    else
      price
    end

  end

  def discounted_total(total)
    return total unless @rules

    @rules.sort_by { |hsh| hsh['min_amount'] }.reverse!

    applicable_rule = {}

    @rules.each do |rule|
      if rule['min_amount'] <= total
        applicable_rule = rule
        break;
      end
    end

    return unless applicable_rule

    case applicable_rule['type']
    when 'percentage'
      discount = (total / 100 * applicable_rule['discount'])
      (total - discount).round(2)
    when 'amount'
      (total - applicable_rule['discount'])
    else
      total
    end
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

end
