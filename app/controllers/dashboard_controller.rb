class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    #FlareMonitorData.import('/NEOSAVVY/work/runenergy/runenergy-biogasdata/db/spreadsheets/test_a.csv')
    @flare_monitor_data = FlareMonitorData.all
  end

  #XHR
  def read_customers
    customers = nil
    unless current_user.is_customer?
      customers = User.where(:user_type_id => UserType.CUSTOMER.id)
    end

    if request.xhr?
      respond_to do |format|
        format.json {
          render json: customers
        }
      end
      return
    end
  end

  def read_locations
    if current_user.is_customer?
      @locations = Location.joins(:flare_deployments).where("flare_deployments.customer_id = ?", current_user.id)
    else
      @locations = Location.all
    end


    if request.xhr?
      respond_to do |format|
        format.json {
          render json: @locations
        }
      end
      return
    end
  end

  #TODO, may be extraneous
  def read_flare_deployments
    if current_user.is_customer?
      flare_deployments = FlareDeployment.where(:customer_id => current_user.id)
    else
      flare_deployments = FlareDeployment.all
    end

    if request.xhr?
      respond_to do |format|
        format.json {
          render json: flare_deployments
        }
      end
      return
    end
  end

  def read_flare_specifications
    if current_user.is_customer?
      flare_specifications = FlareDeployment.where(:customer_id => current_user.id).map { |fd| fd.flare_specification.as_json.merge({:location => fd.location.as_json}) }
    else
      flare_specifications = FlareSpecification.all.map {|fs| fs.as_json.merge({:location => fs.flare_deployment.location.as_json}) }
    end

    if request.xhr?
      respond_to do |format|
        format.json {
          render json: flare_specifications
        }
      end
      return
    end
  end

  def read_flare_monitor_data
    @flare_monitor_data = FlareMonitorData.page(request.GET["start"].try(:to_i) || 0).per(100)

    exceptions = [:id, :created_at, :updated_at]

    if request.xhr?
      respond_to do |format|
        format.json {
          render json: {:header => @flare_monitor_data.first.as_json(:except => exceptions).keys.map { |attribute| FlareMonitorData.display_name_for_field(attribute) }, :values => @flare_monitor_data.map { |fmd| fmd.as_json(:except => exceptions).values }}
        }
      end
      return
    end
  end
end
