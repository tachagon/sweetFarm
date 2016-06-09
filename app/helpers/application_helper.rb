module ApplicationHelper

  def generate_breadcrumb(link = {})
    output = "<ol class='breadcrumb'>"
    link.each do |key, value|
      if value != "active"
        output << "<li><a href='#{value}'>#{key}</a></li>"
      else
        output << "<li class='active'>#{key}</li>"
      end
    end
    output << "</ol>"
    return(output.html_safe)
  end

end
