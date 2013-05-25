module SmartAssignment

  def attributes_ignore_unknown=(attributes)
    self.assign_attributes(
        attributes.reject { |k, v| !self.attributes.keys.member?(k.to_s) }
    )
  end

end