namespace :db_inserts do
  task :attribute_name_mappings => :environment do
    AttributeNameMapping.find_or_create_by_attribute_name(:applies_to_class => 'FlareMonitorData', :attribute_name => 'blower_speed', :display_name => 'Blower Speed')
    AttributeNameMapping.find_or_create_by_attribute_name(:applies_to_class => 'FlareMonitorData', :attribute_name => 'date_time_reading', :display_name => 'Reading At')
    AttributeNameMapping.find_or_create_by_attribute_name(:applies_to_class => 'FlareMonitorData', :attribute_name => 'flame_temperature', :display_name => 'Flame Temperature')
    AttributeNameMapping.find_or_create_by_attribute_name(:applies_to_class => 'FlareMonitorData', :attribute_name => 'inlet_pressure', :display_name => 'Inlet Pressure')
    AttributeNameMapping.find_or_create_by_attribute_name(:applies_to_class => 'FlareMonitorData', :attribute_name => 'lfg_temperature', :display_name => 'LFG Temperature')
    AttributeNameMapping.find_or_create_by_attribute_name(:applies_to_class => 'FlareMonitorData', :attribute_name => 'methane', :display_name => 'Methane')
    AttributeNameMapping.find_or_create_by_attribute_name(:applies_to_class => 'FlareMonitorData', :attribute_name => 'standard_cumulative_lfg_volume', :display_name => 'Standard Cumulative LFG Volume')
    AttributeNameMapping.find_or_create_by_attribute_name(:applies_to_class => 'FlareMonitorData', :attribute_name => 'standard_lfg_flow', :display_name => 'Standard LFG Flow')
    AttributeNameMapping.find_or_create_by_attribute_name(:applies_to_class => 'FlareMonitorData', :attribute_name => 'standard_lfg_volume', :display_name => 'Standard LFG Volume (Month to Date)')
    AttributeNameMapping.find_or_create_by_attribute_name(:applies_to_class => 'FlareMonitorData', :attribute_name => 'standard_methane_volume', :display_name => 'Standard Methane Volume (Month to Date')
    AttributeNameMapping.find_or_create_by_attribute_name(:applies_to_class => 'FlareMonitorData', :attribute_name => 'static_pressure', :display_name => 'Static Pressure')
  end
end