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

end