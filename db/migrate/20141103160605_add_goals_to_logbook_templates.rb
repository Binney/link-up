class AddGoalsToLogbookTemplates < ActiveRecord::Migration
  def change
  	add_column :logbook_templates, :goal, :text
  	add_column :logbook_entries,   :goal, :text
  end
end
