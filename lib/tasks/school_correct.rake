namespace :db do
  desc "Correct errors"
  task school_correct: :environment do
  	User.find_by(name: "Link Up Admin").update_attribute(:role, "admin")
  end
end