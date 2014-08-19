class AddAboutMeToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :about, :text
  	add_column :users, :interests, :text
  end
end
