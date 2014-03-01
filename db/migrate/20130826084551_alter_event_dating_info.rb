class AlterEventDatingInfo < ActiveRecord::Migration
  def change
    remove_column :events, :start_time
    remove_column :events, :end_time
    remove_column :events, :day
    add_column :timings, :day, :integer
    remove_column :diary_entries, :repeating
    remove_column :favourites, :schedule
    add_column :favourites, :day, :integer
  end
end
