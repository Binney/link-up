class AddStartTimeToLogbookTemplates < ActiveRecord::Migration
  def change
  	add_column :logbook_templates, :start_time, :datetime
  end
end
