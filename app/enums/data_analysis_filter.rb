class DataAnalysisFilter < ClassyEnum::Base
end

class DataAnalysisFilter::Asset < DataAnalysisFilter
  def description
    'Display by Asset'
  end
end

class DataAnalysisFilter::FieldLog < DataAnalysisFilter
  def description
    'Display by Field Log'
  end
end

class DataAnalysisFilter::Section < DataAnalysisFilter
  def description
    'Display by Section'
  end
end

class DataAnalysisFilter::AssetType < DataAnalysisFilter
  def description
    'Display by Asset Type'
  end
end
