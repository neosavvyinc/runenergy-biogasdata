class DashboardController < ApplicationController
  include AjaxHelp

  before_filter :authenticate_user!

  def index
    #Serves up the index page, nothing else
  end

  #XHR
  def read_current_user
    render json: current_user
  end

  def read_customers
    customers = nil
    unless current_user.is_customer?
      customers = User.where(:user_type_id => UserType.CUSTOMER.id)
    end

    render json: customers
  end

  def read_locations
    if current_user.is_customer?
      @locations = Location.joins(:flare_deployments).where('flare_deployments.customer_id = ?', current_user.id)
    elsif not request.GET['customerId'].nil?
      @locations = Location.joins(:flare_deployments).where('flare_deployments.customer_id = ?', request.GET['customerId'].to_i)
    else
      @locations = Location.all
    end

    @locations = @locations.map { |location|
      location.as_json.merge({:flare_specifications => location.flare_specifications}) }

    render json: @locations
  end

  def read_flare_deployments
    if current_user.is_customer?
      flare_deployments = FlareDeployment.where(:customer_id => current_user.id)
    else
      flare_deployments = FlareDeployment.all
    end

    render json: flare_deployments
  end

  def read_flare_specifications
    if current_user.is_customer?
      flare_specifications = FlareDeployment.where(:customer_id => current_user.id).map { |fd| fd.flare_specification.as_json.merge({:location => fd.location.as_json}) }
    else
      flare_specifications = FlareSpecification.all.map { |fs| fs.as_json.merge({:location => fs.flare_deployment.location.as_json}) }
    end

    render json: flare_specifications
  end

  def create_session
    session[:constraints] = params_to_session(params)

    render json: {:constraints => session[:constraints]}
  end

  def read_flare_monitor_data
    session[:constraints] ||= params_to_session(params)
    flare_deployment = FlareDeployment.where(:customer_id => current_user.id, :flare_specification_id => params[:flareSpecificationId]).first
    flare_monitor_data = FlareMonitorData.date_range(current_user.user_type,
                                                     flare_deployment,
                                                     params[:flareSpecificationId],
                                                     session[:constraints][:start_date],
                                                     session[:constraints][:end_date],
                                                     session[:constraints][:start_time],
                                                     session[:constraints][:end_time])
    logger.info session[:constraints]
    flare_monitor_data = FlareMonitorData.with_filters(flare_monitor_data, session[:constraints][:filters])

    exceptions = [:id, :created_at, :updated_at]

    #Clear out session constraints
    session[:constraints] = nil

    if request.xhr?
      #Paging Support
      flare_monitor_data = flare_monitor_data.page((request.GET['start'].try(:to_i) or 0)).per(600)
      keys = FlareMonitorData.first.as_json(:except => exceptions).keys.
          sort_by { |attribute|
        (FlareMonitorData.display_object_for_field(attribute).try(:column_weight) or 0)
      }
      header = keys.map { |attribute| FlareMonitorData.display_object_for_field(attribute) }.
          concat(AttributeNameMapping.calculation_headings)
      methods = [:energy, :methane_tonne]
      all_keys = keys.concat(methods)
      values = flare_monitor_data.map { |fmd| fmd.as_json_from_keys(all_keys, {:except => exceptions, :methods => methods}) }
      render json: {:header => header, :values => values}
    else
      respond_to do |format|
        flare_monitor_csv = FlareMonitorData.to_csv(flare_monitor_data, exceptions)
        format.csv { send_data flare_monitor_csv }
      end
    end
  end

  protected
  def params_to_session(params)
    {
        :start_date => ajax_value_or_nil(params[:startDate]),
        :end_date => ajax_value_or_nil(params[:endDate]),
        :start_time => ajax_value_or_nil(params[:startTime]),
        :end_time => ajax_value_or_nil(params[:endTime]),
        :filters => params[:filters]
    }
  end
end
