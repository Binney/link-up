class LogbookEntry < ActiveRecord::Base
	belongs_to :user
	validates :user_id, presence: true
	belongs_to :logbook_template, foreign_key: "template_id"
end
