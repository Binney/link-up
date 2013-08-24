class CreateTimings < ActiveRecord::Migration
  def change
    create_table :timings do |t|
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
