class DataCollisionController < DataInterfaceController

  include AjaxHelp
  before_filter :authenticate_user!

  def index
    @data_collision_blocks = {}
    if current_user.edit_permission
      current_user.all_locations.each do |l|
        l.locations_monitor_classes.each do |lmc|
          @data_collision_blocks[lmc.display_name] = []
          Asset.where(:location_id => l, :monitor_class_id => lmc.monitor_class_id).each do |a|
            @data_collision_blocks[lmc.display_name] = @data_collision_blocks[lmc.display_name].concat(DataCollision.joins(:readings).where('readings.asset_id = ?', a.id).map {|dc| dc})
          end
          @data_collision_blocks[lmc.display_name].uniq!
          @data_collision_blocks[lmc.display_name].compact!
        end
      end
    else
      redirect_to 'data_analysis#index'
    end
  end

  def resolve
    unless params[:collision_id].nil? or params[:reading_id].nil?
      dc = DataCollision.where(:id => params[:collision_id]).first
      reading = Reading.where(:id => params[:reading_id]).first
      if dc.try(:readings).try(:include?, reading)
        dc.readings.each do |r|
          unless r.id == reading.id
            r.delete
          end
        end

        #Remove data collision
        dc.delete

        #Update reading not to include it
        reading.update_attribute(:data_collision_id, nil)

        render json: dc
      else
        render json: {:error => 'You have passed invalid or unmatching data collision and reading ids.'}, :status => 400
      end
    else
      render json: {:error => 'You must pass a valid collision_id and reading_id to complete the resolution request.'}, :status => 400
    end
  end

end