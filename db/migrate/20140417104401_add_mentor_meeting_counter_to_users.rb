class AddMentorMeetingCounterToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :mentor_meetings, :integer, default: 0
  	add_index :users, :mentor_meetings
  end
end
