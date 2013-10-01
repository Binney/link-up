class AddUserIdToEventsPlusDeleteBoolAbilities < ActiveRecord::Migration
  def change
    add_column :events, :user_id, :integer
    remove_column :users, :admin
    remove_column :users, :mentor
    remove_column :users, :organiser
  end
end
