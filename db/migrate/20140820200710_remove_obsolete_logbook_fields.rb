class RemoveObsoleteLogbookFields < ActiveRecord::Migration
  def change
  	remove_column :logbook_entries, :mentor_meeting
  	remove_column :logbook_entries, :event_id
  	remove_column :logbook_entries, :date
  	add_column :logbook_templates, :title, :string
  end
end
