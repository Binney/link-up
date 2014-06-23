class AddVenueIdToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :venue_id, :integer
  end
end
