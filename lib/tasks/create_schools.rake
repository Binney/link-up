namespace :db do
  desc "Find all users who appear to attend each school and correct their entries"
  task create_schools: :environment do
	School.create!(venue_id: 48, teacher_code: "Westminster Academy Teacher", student_code: "Westminster Academy Student")
  end
end