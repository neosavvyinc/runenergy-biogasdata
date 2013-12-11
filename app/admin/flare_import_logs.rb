ActiveAdmin.register FlareImportLog, :as => 'Log' do
  menu :parent => 'Flares'

  index do
    column :flare_unique_identifier
    column :message
    column :likely_cause
    column :created_at
    default_actions
  end
end
