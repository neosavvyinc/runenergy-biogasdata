module Field
  class API < Grape::API

    version 'v1'
    format :json

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
        Location.all.as_json(:methods => [:monitor_class_ids])
      end
    end

    resource :monitor_classes do
      get do
        MonitorClass.all.as_json(:include => [:monitor_points, :field_log_points])
      end
    end

    resource :readings do
      params do
        requires :site_id, type: String
        requires :class_id, type: String
      end
      get do
        count = params[:count].try(:to_i) || 10
        Reading
        .where(:location_id => params[:site_id].to_i)
        .where(:monitor_class_id => params[:class_id].to_i)
        .limit(count)
      end

      params do
        requires :site_id, type: String
        requires :class_id
        requires :field_log
        requires :reading
      end
      post '/create' do
        field_log = FieldLog.create({
                                        :data => JSON.dump(params[:field_log])
                                    })
        Reading.create({
                           :location_id => params[:site_id].to_i,
                           :monitor_class_id => params[:class_id].to_i,
                           :field_log_id => field_log.id,
                           :data => JSON.dump(params[:reading])
                       })
      end
    end

  end
end