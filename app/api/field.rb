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
    #resource :sync do
    #  params do
    #    requires :uid, type: String
    #  end
    #  get do
    #    device_profile = DeviceProfile.where(:uid => params[:uid]).first
    #    if device_profile
    #      device_profile.unique_users.as_json(:methods => [:entitled_site_ids])
    #    else
    #      error!('MODELNOTFOUND', 404)
    #    end
    #  end
    #end

    resource :token do
      post '/create' do
        email = params[:email]
        password = params[:password]

        if email.nil? or password.nil?  # Ensure that both email and password are not nil
          error!('The request must contain the user email and password.', 400)
        end

        @user=User.find_by_email(email.downcase) #Find the User
        if @user.nil? # If user does not exist
          error!('Invalid email or passoword.', 401)
        end

        @user.ensure_authentication_token! #Generates a new token for the user
        if not @user.valid_password?(password) # Check the password
          error!('Invalid email or password.', 401)
        else
          @user.save # Save the token into the database
          {:token=>@user.authentication_token}
        end
      end

      post '/destroy' do
        @user=User.find_by_authentication_token(params[:authentication_token])
        if @user.nil?
          error!('Invalid token.', 404)
        else
          @user.reset_authentication_token!
          {:token=>params[:authentication_token]}
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
          Reading
          .where(:location_id => params[:site_id].to_i)
          .where(:monitor_class_id => params[:class_id].to_i)
          .limit(params[:count].try(:to_i) || 10)
        else
          error!('User is not entitled to site. Bad ID value.', 401)
        end
      end

      params do
        requires :site_id
        requires :class_id
        requires :field_log
        requires :reading
        requires :asset_unique_identifier
        requires :date_time
      end
      post '/create' do
        if authenticated? and current_user.is_entitled_to?(params[:site_id])
          unless LocationsMonitorClass.where(:location_id => params[:site_id], :monitor_class_id => params[:class_id]).empty?
            if params[:date_time].to_s.size == 10 and params[:date_time].to_s.numeric?
              field_log = FieldLog
              .find_or_create_by_data(JSON.dump(params[:field_log]))
              Reading.create({
                                 :location_id => params[:site_id],
                                 :monitor_class_id => params[:class_id],
                                 :asset_id => Asset.lazy_load(params[:site_id], params[:asset_unique_identifier]).id,
                                 :field_log_id => field_log.id,
                                 :data => JSON.dump(params[:reading]),
                                 :taken_at => DateTime.strptime(params[:date_time].to_s, '%s')
                             })
            else
              error!('Date time readings must be passed in Unix (Time Since Epoch) format.', 401)
            end
          else
            error!('Monitor class and location are not associated in the admin. You have made an invalid selection.', 401)
          end
        else
          error!('User is not entitled to site. Bad ID value.', 401)
        end
      end
    end

  end
end