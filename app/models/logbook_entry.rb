class LogbookEntry < ActiveRecord::Base
	belongs_to :user
	validates :user_id, presence: true
	belongs_to :logbook_template

	def is_complete
		complete = 2
		answers = (content+"bookend").split("<template>")
		answers.each do |ans|
			if ans.blank?
				complete = 1
			end
		end
		complete
	end
end
