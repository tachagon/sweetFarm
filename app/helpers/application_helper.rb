module ApplicationHelper

  def generate_breadcrumb(link = {})
    output = "<ol class='breadcrumb'>"
    link.each do |title, href|
      if href != "active"
        output << "<li><a href='#{href}'>#{title}</a></li>"
      else
        output << "<li class='active'>#{title}</li>"
      end
    end
    output << "</ol>"
    return(output.html_safe)
  end

  def no_precision(num)
    return number_with_precision(num, precision: 0)
  end

  def delimiter(num)
    return number_with_delimiter(num, delimiter: ",")
  end

end
