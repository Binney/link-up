class LogbookTemplate < ActiveRecord::Base
	has_many :logbook_entries
end