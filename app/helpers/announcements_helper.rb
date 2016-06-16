module AnnouncementsHelper

  def get_announcement_role_th(role)
    if role == "sale"
      "ขายอ้อย"
    else
      "ซื้ออ้อย"
    end
  end

  def get_deal_status(announcement)
    deals = announcement.deals
    deals.each do |deal|
      return "ซื้อขายสำเร็จแล้ว" if completed?(deal)
      return "ได้รับรีวิวแล้ว" if reviewed?(deal)
      return "ขนส่งแล้ว" if shipped?(deal)
      return "ชำระเงินแล้ว" if paid?(deal)
      return "รับข้อเสนอแล้ว" if accepted?(deal)
    end
  end

  def accept_announcement?(announcement)
    deals = announcement.deals
    deals.each do |deal|
      return true if accepted?(deal) || paid?(deal) || shipped?(deal) || reviewed?(deal) || completed?(deal)
    end
    return false
  end

  def accepted?(deal)
    if deal.status == "accepted"
      true
    else
      false
    end
  end

  def paid?(deal)
    if deal.status == "paid"
      true
    else
      false
    end
  end

  def shipped?(deal)
    if deal.status == "shipped"
      true
    else
      false
    end
  end

  def reviewed?(deal)
    if deal.status == "reviewed"
      true
    else
      false
    end
  end

  def completed?(deal)
    if deal.status == "completed"
      true
    else
      false
    end
  end

end
