module AjaxHelp
  def ajax_value_or_nil(value)
    if value.nil? or value.to_s.empty? or value == 'null' or value == 'undefined'
      nil
    else
      value
    end
  end

  def date_time_from_js(date, time=nil)
    date = date.gsub(/T.*/, '')
    if time.nil?
      DateTime.strptime(date, '%Y-%m-%d')
    else
      DateTime.strptime(date + time, '%Y-%m-%d%H:%M:%S')
    end
  end
end