namespace :db do
  desc "Find all users who appear to attend each school and correct their entries"
  task create_schools: :environment do
	School.create!(venue_id: 1)
	School.create!(venue_id: 33, teacher_code: "Dagenham Park Teacher", student_code: "Dagenham Park Student")
  end
end