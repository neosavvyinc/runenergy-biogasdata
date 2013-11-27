module Field
  class API < Grape::API

    version 'v1'
    format :json

    resource :sites do
      get do
        Location.all
      end
    end

    resource :monitor_classes do
      get do
        MonitorClass.all.as_json(:include => [:monitor_points, :field_log_points])
      end
    end

  end
end