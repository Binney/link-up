class AddLocationToDiaryEntries < ActiveRecord::Migration
  def change
    add_column :diary_entries, :location, :string
  end
end
