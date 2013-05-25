class DashboardController < ApplicationController
  def login
  end

  def index
    #FlareMonitorData.import('/NEOSAVVY/work/runenergy/runenergy-biogasdata/db/spreadsheets/test_a.csv')
    @flare_monitor_data = FlareMonitorData.all
  end

  def read
    @flare_monitor_data = FlareMonitorData.all

    exceptions = [:id, :created_at, :updated_at]

    if request.xhr?
      respond_to do |format|
        format.json {
          render json: {:header => @flare_monitor_data.first.as_json(:except => exceptions).keys, :values => @flare_monitor_data.map { |fmd| fmd.as_json(:except => exceptions).values }}
        }
      end
      return
    end
  end
end
