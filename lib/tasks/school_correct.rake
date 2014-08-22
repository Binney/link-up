namespace :db do
  desc "Correct errors"
  task school_correct: :environment do
  	User.find(1).update_attribute(:role, "admin")
	end

end