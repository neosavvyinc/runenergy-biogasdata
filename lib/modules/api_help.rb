module ApiHelp

  def ids_names_as_array(ids, class_def, property_name = 'name')
    unless ids.blank?
      ids = ids.to_s.split(',').map {
          |id|
        id = id.strip
        if id.numeric?
          id.to_i
        else
          class_def.where("#{property_name} = ?", id).first.try(:id)
        end
      }
    end
  end

end