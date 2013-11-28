class CreateUserGroupsUsers < ActiveRecord::Migration
  def change
    create_table :user_groups_users, :id => false do |t|
      t.integer :user_group_id
      t.integer :user_id

      t.timestamps
    end
  end
end
