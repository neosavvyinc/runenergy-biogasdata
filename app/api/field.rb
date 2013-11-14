module Field
  class API < Grape::API

    version 'v1'
    format :json

    resource :monitor_classes do
      get do
        MonitorClass.all
      end
    end

  end
end