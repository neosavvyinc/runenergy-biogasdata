class DashboardController < ApplicationController
  def login
  end

  def index
    #FlareMonitorData.import('/NEOSAVVY/work/runenergy/runenergy-biogasdata/db/spreadsheets/test_a.csv')
    @flare_monitor_data = FlareMonitorData.all
  end

  def read
    @flare_monitor_data = FlareMonitorData.all

    if request.xhr?
      respond_to do |format|
        format.json {
          render json: @flare_monitor_data
        }
      end
      return
    end
  end
end
