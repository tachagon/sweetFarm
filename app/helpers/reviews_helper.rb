module ReviewsHelper

  def show_rating(rating_avg)
    output = content_tag(:div, "")
    rating_remain = rating_avg % 1
    rating_int = rating_avg - rating_remain

    for i in 0...rating_int
      output += content_tag(:sapn, "", class: "fa fa-star")
    end

    for i in 0...(5 - rating_int)
      if (i == 0) && (rating_remain >= 0.5)
        output += content_tag(:sapn, "", class: "fa fa-star-half-o")
      else
        output += content_tag(:sapn, "", class: "fa fa-star-o")
      end
    end

    return output

  end

  def get_rating_avg(user)
    sum = 0.0
    user.passive_reviews.each do |review|
      sum += review.rating
    end
    return sum / user.passive_reviews.count
  end

end
