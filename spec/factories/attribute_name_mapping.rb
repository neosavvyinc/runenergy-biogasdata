FactoryGirl.define do
  factory :attribute_name_mapping do |val|

  end
  AttributeNameMapping.find_by_attribute_name('blower_speed') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'blower_speed')
  AttributeNameMapping.find_by_attribute_name('date_time_reading') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'date_time_reading')
  AttributeNameMapping.find_by_attribute_name('flame_temperature') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'flame_temperature')
  AttributeNameMapping.find_by_attribute_name('inlet_pressure') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'inlet_pressure')
  AttributeNameMapping.find_by_attribute_name('lfg_temperature') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'lfg_temperature')
  AttributeNameMapping.find_by_attribute_name('methane') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'methane')
  AttributeNameMapping.find_by_attribute_name('standard_cumulative_lfg_volume') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'standard_cumulative_lfg_volume')
  AttributeNameMapping.find_by_attribute_name('standard_lfg_flow') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'standard_lfg_flow')
  AttributeNameMapping.find_by_attribute_name('standard_lfg_volume') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'standard_lfg_volume')
  AttributeNameMapping.find_by_attribute_name('standard_methane_volume') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'standard_methane_volume')
  AttributeNameMapping.find_by_attribute_name('static_pressure') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'static_pressure')
  AttributeNameMapping.find_by_attribute_name('flame_trap_temperature') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'flame_trap_temperature')
  AttributeNameMapping.find_by_attribute_name('flare_run_hours') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'flare_run_hours')
  AttributeNameMapping.find_by_attribute_name('flare_specification_id') or FactoryGirl.create(:attribute_name_mapping, :attribute_name => 'flare_specification_id')
end