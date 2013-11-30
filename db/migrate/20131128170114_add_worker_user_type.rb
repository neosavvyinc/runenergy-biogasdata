class AddWorkerUserType < ActiveRecord::Migration
  def change
    UserType.create(:name => "WORKER")
  end
end
