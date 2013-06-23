ActiveAdmin.register FlareMonitorData do
  menu :parent => "Flares"

  index do
    column :flare_specification
    column :date_time_reading
    column :blower_speed
    column :flare_run_hours
    column :flame_temperature
    column :flame_trap_temperature
    column :inlet_pressure
    column :lfg_temperature
    column :methane
    column :standard_cumulative_lfg_volume
    column :standard_lfg_flow
    column :standard_lfg_volume
    column :standard_methane_volume
    column :static_pressure
    default_actions
  end

end
