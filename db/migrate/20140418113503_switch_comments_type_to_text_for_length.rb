class SwitchCommentsTypeToTextForLength < ActiveRecord::Migration
  def change
  	change_column :reviews, :content, :text, limit: nil
  	change_column :venues, :description, :text, limit: nil
  	change_column :articles, :content, :text, limit: nil
  	change_column :events, :description, :text, limit: nil
  	change_column :logbook_entries, :content, :text, limit: nil
  	change_column :messages, :message, :text, limit: nil
  end
end
