class VisualizationsController < DataInterfaceController
  include AjaxHelp
  before_filter :authenticate_user!

  def monitor_point_progress
    @monitor_point = MonitorPoint.find(params[:monitor_point_id])
    @readings = Reading.where(:location_id => params[:site], :monitor_class_id => params[:monitor_class])

    #Asset and section optional filters
    if params[:asset]
      @readings = @readings.where(:asset_id => params[:asset])
    elsif params[:section]
      @readings = @readings.joins(:asset).where(:assets => {:section_id => params[:section]})
    end

    #Start and end date optional filters
    if params[:start]
      @readings = @readings.where('taken_at >= ?', DateTime.strptime(params[:start].to_s, '%s'))
    end
    if params[:end]
      @readings = @readings.where('taken_at <= ?', DateTime.strptime(params[:end].to_s, '%s'))
    end

    @readings = @readings.order('taken_at').map {
        |r| [(r.taken_at.try(:strftime, '%Y%m%d') || r.created_at.try(:strftime, '%Y%m%d')), JSON.parse(r.data)[@monitor_point.try(:name)]]
    }

    #Constraints
    hl = calculate_high_low_y_axis(@readings)
    @high_y = hl[:high_y]
    @low_y = hl[:low_y]
  end

  def heat_map
    unless params[:site].nil? or params[:monitor_class].nil?
      location = Location.find(params[:site])
      monitor_class = MonitorClass.find(params[:monitor_class])
      @locations_monitor_class = LocationsMonitorClass.lazy_load(params[:site], params[:monitor_class])
      @asset_map = HeatMapDetail.asset_map(:location => location, :monitor_class => monitor_class)
      @reading_map = HeatMapDetail.reading_map(:location => location,
                                               :monitor_class => monitor_class,
                                               :monitor_point => MonitorPoint.find(params[:monitor_point_id]),
                                               :start_date => date_time_or_nil(params[:start_date]),
                                               :end_date => date_time_or_nil(params[:end_date])
      )

      #Can be more efficient and re-factored later, not sure if we will need this
      #asset_group = @asset_map.group_by {|row|"X:#{row[:x]}Y:#{row[:y]}"}
      #reading_group = @reading_map.group_by {|row| "X:#{row[:x]}Y:#{row[:y]}"}
      #
      #@asset_map.reject! {|row| reading_group["X:#{row[:x]}Y:#{row[:y]}"].nil?}
      #@reading_map.reject! {|row| asset_group["X:#{row[:x]}Y:#{row[:y]}"].nil?}
    else
      render json: {:error => 'You must pass in a valid location and monitor class id.'}, :status => 400
    end
  end

  protected
  def calculate_high_low_y_axis(readings)
    unless readings.nil? or readings.empty?
      low_y = nil
      high_y = nil
      readings.each do |r|
        val = r[1].try(:to_f)
        if low_y.nil? and high_y.nil?
          low_y = high_y = val
        elsif val > high_y
          high_y = val
        elsif val < low_y
          low_y = val
        end
      end

      margin = (high_y - low_y) / 5

      {:high_y => (high_y + margin).round(2), :low_y => (low_y - margin).round(2)}
    else
      {:high_y => 0, :low_y => 0}
    end
  end
end