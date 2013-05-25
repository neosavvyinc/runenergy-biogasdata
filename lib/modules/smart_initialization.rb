module SmartInitialization

  def self.included(clazz)
    clazz.extend(SmartInitializationMethods)
  end

  module SmartInitializationMethods
    def new_ignore_unknown(attributes, options = {})
      item = self.new
      item.assign_attributes(
          attributes.reject { |k, v| !item.attributes.keys.member?(k.to_s) },
          options)
      item
    end
  end

end