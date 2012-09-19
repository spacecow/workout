class ColourPickerFormBuilder < SimpleForm::FormBuilder
 def color_picker(method, options={})
    toret = "<div class=\"colorpicker\"><label>Intesity</label>" 
    options[:available].each_pair do |key,opt|
      toret += "<div id=\"coloritem_#{key}\" class=\"coloritem " + (opt == options[:available][options[:selected]] ? "cpselected" : "") + "\" style=\"background: #{opt}\">" 
      toret += "<a href=\"#\" onClick=\"set_color_picker('coloritem_#{key}','#{key}');return false;\">#{key}</a>" 
      toret += "</div>\n" 
    end
    toret += "<input type=\"hidden\" name=\"#{@object_name.to_s}[#{method.to_s}]\" value=\"#{options[:selected]}\" id=\"hidden_color_picker\"/>" 
    toret += "<div class=\"clear\"></div>" 
    toret += "</div>" 
    return toret.html_safe
  end
end
