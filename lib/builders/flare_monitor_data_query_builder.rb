class FlareMonitorDataQueryBuilder

  def initialize(query=nil)
    @query = query
  end

  def where_filter(attribute, filter_expression)
    @query ||= FlareMonitorData
    @query = @query.where("#{attribute.to_s} #{filter_expression}")
    return self
  end

  def query
    @query
  end

end