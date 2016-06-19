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

  def show_purchaser(deal, user)
    if is_purchaser?(deal, user)
      return "ผู้ซื้อ"
    else
      return "ผู้ขาย"
    end
  end

  def find_reviewed(deal, user)
    announcements = deal.announcements

    other_user = nil
    announcements.each do |announcement|
      if announcement.user != user
        other_user = announcement.user
      end
    end
    other_user = deal.user if other_user.nil?
    return other_user
  end

  # Returns true if user is reviewd deal
  def review_deal?(deal, user)
    reviews = deal.reviews

    reviews.each do |review|
      return true if review.reviewer == user
    end
    return false
  end

  # if user accepted a deal
  # then status of other deals of same announcement should be decline
  def decline_others_deal(announcements, deal_accepted_id)
    announcements.each do |announcement|
      announcement.deals.each do |deal|
        if deal.id != deal_accepted_id
          deal.status = 'decline'
          deal.save
        end
      end
    end
  end

end
