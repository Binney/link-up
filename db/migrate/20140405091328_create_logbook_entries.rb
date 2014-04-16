class CreateLogbookEntries < ActiveRecord::Migration
  def change
    create_table :logbook_entries do |t|
      t.integer :user_id
      t.boolean :mentor_meeting
      t.integer :event_id
      t.string :content
      t.datetime :date

      t.timestamps
    end
  end
end
