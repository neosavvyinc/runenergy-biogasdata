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
            @data_collision_blocks[lmc.display_name] << DataCollision.joins(:readings).where('readings.asset_id = ?', a.id)
          end
          @data_collision_blocks[lmc.display_name].uniq!
        end
      end
    else
      redirect_to :controller => DataAnalysisController, :action => :index
    end
  end

end