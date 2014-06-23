namespace :db do
  desc "Find all users who appear to attend each school and correct their entries"
  task school_correct: :environment do
    @schools = School.all
    @schools.each do |school|
    	n = 0
	    @users = User.all.search(:school_cont => school.name[0..8]).result
	    @users.each do |user|
	      user.update_attributes(school: school.name,
	      						 					 school_id: school.id)
	      n += 1
	    end
	    school.update_attribute(:student_quantity, n)
	  end
	end

end