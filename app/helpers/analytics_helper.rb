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

  def sum_amount_by_day(announcements, day, month, year)
    sum = 0
    announcements.each do |announcement|
      created_at = announcement.created_at
      sum += announcement.amount if created_at.day == day && created_at.month == month && created_at.year == year
    end
    return sum
  end

  def avg_price_by_day(announcements, day, month, year)
    sum = 0
    num = 0
    announcements.each do |announcement|
      created_at = announcement.created_at
      if created_at.day == day && created_at.month == month && created_at.year == year
        sum += announcement.price
        num += 1
      end
    end
    return (num != 0) ? precision(sum/num, 2):0
  end

end
