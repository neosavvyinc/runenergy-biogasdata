module MappingHelp

  def self.included(clazz)
    clazz.extend(MappingHelpMethods)
  end

  module MappingHelpMethods
    def map_with_key(query, property = :id)
      hash = {}
      unless query.nil?
        query.each do |val|
          hash[val[property.to_sym].to_s] = val.as_json
        end
      end
      hash
    end
  end

end