class AddEditToUsersAndGroups < ActiveRecord::Migration
  def change
    add_column :users, :edit_permission, :boolean
    add_column :user_groups, :edit_permission, :boolean
  end
end
