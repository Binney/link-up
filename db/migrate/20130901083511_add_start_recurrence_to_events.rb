class AddStartRecurrenceToEvents < ActiveRecord::Migration
  def change
    add_column :favourites, :start_time, :datetime
    remove_column :favourites, :day
  end
end
