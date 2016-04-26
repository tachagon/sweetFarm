module DealsHelper

  def show_deal_status(deal)
    word = ""
    color = ""
    if deal.status == "decline"
      word = "ข้อเสนอถูกปฏิเสธ"
      color = "red"
    elsif deal.status == "wait"
      word = "กำลังพิจารณาข้อเสนอ"
      color = "gray"
    elsif deal.status == "accepted"
      word = "รับข้อเสนอแล้ว"
      color = "green"
    elsif deal.status == "paid"
      word = "ชำระเงินแล้ว"
      color = "green"
    elsif deal.status == "shipped"
      word = "ขนส่งแล้ว"
      color = "green"
    elsif deal.status == "reviewed"
      word = "ได้รับรีวิวแล้ว"
      color = "green"
    elsif deal.status == "completed"
      word = "ซื้อขายสำเร็จแล้ว"
    end
    content_tag(:p, word, style: "color: #{color};", class: "center")
  end

  def is_purchaser?(deal, user)
    announcements = deal.announcements

    announcements.each do |announcement|
      if (announcement.role == "purchase" && announcement.user == user) || (announcement.role == "sale" && deal.user == user)
        return true
      end
    end
    return false
  end

end
