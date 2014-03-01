class AddHomeAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :gmaps, :boolean, default: 1 
  end
end
