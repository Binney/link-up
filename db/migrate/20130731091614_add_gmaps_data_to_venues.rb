class AddGmapsDataToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :street_address, :string # e.g. '54 Chatsworth Road'
    add_column :venues, :latitude, :float
    add_column :venues, :longitude, :float
    add_column :venues, :gmaps, :boolean, default: 1 
  end
end
