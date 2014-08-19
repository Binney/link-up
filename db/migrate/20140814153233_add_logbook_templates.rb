class AddLogbookTemplates < ActiveRecord::Migration
  def change
  	create_table :logbook_templates do |t|
  		t.text :content
  		t.integer :user_id
  		t.datetime :deadline

  		t.timestamps
  	end
  	add_column :logbook_entries, :template_id, :integer
  	add_index :logbook_entries, [:user_id, :template_id], unique: true
  end
end
