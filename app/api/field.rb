module Field
  class API < Grape::API

    version 'v1'
    format :json

    #API Authentication, may make sense to pull out into reusable form
    helpers do
      def warden
        env['warden']
      end

      def authenticated?
        if warden.authenticated?
          return true
        elsif params[:authentication_token] and
            User.find_by_authentication_token(params[:authentication_token])
          return true
        else
          error!({'error' => 'Unauth 401. Token invalid'}, 401)
        end
      end

      def current_user
        warden.user || User.find_by_authentication_token(params[:authentication_token])
      end
    end

    #Not sure what to do with this just yet
    resource :sync do
      params do
        requires :uid, type: String
      end
      get do
        device_profile = DeviceProfile.where(:uid => params[:uid]).first
        if device_profile
          device_profile.unique_users.as_json(:methods => [:entitled_site_ids])
        else
          error!('MODELNOTFOUND', 404)
        end
      end
    end

    resource :sites do
      get do
        if authenticated?
          current_user.
              all_locations.
              as_json(:include => [:assets, :locations_monitor_classes => {:include => [:monitor_points, :field_log_points]}])
        end
      end
    end

    resource :readings do
      params do
        requires :site_id, type: String
        requires :class_id, type: String
      end
      get do
        if authenticated? and current_user.is_entitled_to?(params[:site_id])
          count = params[:count].try(:to_i) || 10
          Reading
          .where(:location_id => params[:site_id].to_i)
          .where(:monitor_class_id => params[:class_id].to_i)
          .limit(count)
        else
          error?('User is not entitled to site. Bad ID value.', 401)
        end
      end

      params do
        requires :site_id, type: String
        requires :class_id
        requires :field_log
        requires :reading
      end
      post '/create' do
        if authenticated? and current_user.is_entitled_to?(params[:site_id])
          field_log = FieldLog.create({
                                          :data => JSON.dump(params[:field_log])
                                      })
          Reading.create({
                             :location_id => params[:site_id].to_i,
                             :monitor_class_id => params[:class_id].to_i,
                             :field_log_id => field_log.id,
                             :data => JSON.dump(params[:reading])
                         })
        else
          error?('User is not entitled to site. Bad ID value.', 401)
        end
      end
    end

  end
end