class LogbookTemplate < ActiveRecord::Base
	has_many :logbook_entries, foreign_key: 'template_id'
	belongs_to :school
  default_scope -> { order('deadline ASC') }
end