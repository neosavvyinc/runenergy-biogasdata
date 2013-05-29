module AjaxHelp
  def ajax_value_or_nil(value)
    if value.nil? or value.empty? or value == 'null' or value == 'undefined'
      nil
    else
      value
    end
  end
end