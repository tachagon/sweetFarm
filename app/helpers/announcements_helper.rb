module AnnouncementsHelper

  def get_announcement_role_th(role)
    if role == "sale"
      "ขายอ้อย"
    else
      "ซื้ออ้อย"
    end
  end

end
