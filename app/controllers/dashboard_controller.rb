class DashboardController < ApplicationController
  def login
  end

  def index
    FlareMonitorData.import('/NEOSAVVY/work/runenergy/runenergy-biogasdata/db/spreadsheets/test_a.csv')
  end
end
