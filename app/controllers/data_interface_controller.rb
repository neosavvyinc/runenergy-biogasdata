class DataInterfaceController < ApplicationController

  protected
  def all_view_classes
    @landfill_operators = User.where(:user_type_id => UserType.CUSTOMER.id)
    @sites = Location.all
    @sections = Section.all
    @assets = Asset.all
    @monitor_classes = MonitorClass.all
    @filter_types = DataAnalysisFilter.all.map {
        |d| {:filter => d, :name => d.description}
    }
  end

end