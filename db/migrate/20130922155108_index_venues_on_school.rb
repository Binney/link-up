class IndexVenuesOnSchool < ActiveRecord::Migration
  def change
    add_index :venues, :is_school
  end
end
