class LogbookTemplate < ActiveRecord::Base
	has_many :logbook_entries, foreign_key: 'template_id'
end