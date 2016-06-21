module AnalyticsHelper

  def suggestion_price(deals_hash)
    max_count = 0
    max_price = 0
    deals_hash.each do |price, count|
      if count >= max_count
        max_count = count
        max_price = price
      end
    end
    return max_count > 0 ? max_price:"ไม่มีข้อมูล"
  end

end
