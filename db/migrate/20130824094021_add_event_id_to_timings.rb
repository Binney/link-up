class AddEventIdToTimings < ActiveRecord::Migration
  def change
    add_column :timings, :event_id, :integer
  end
end
