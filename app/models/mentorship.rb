class Mentorship < ActiveRecord::Base
  belongs_to :mentor, class_name: "User"
  belongs_to :mentee, class_name: "User"
  validates :mentor_id, presence: true
  validates :mentee_id, presence: true

  def approve_by(user)
    if user.id == mentee_id && confirmation_stage % 2 == 0
      if self.update_attribute(:confirmation_stage, confirmation_stage+1)
        if confirmation_stage == 3
          puts "Approved! #{User.find(mentor_id)} is now your mentor."
        else
          puts "Approved! Now you just need a teacher or admin to approve the request and you're all set."
        end
      end

    elsif (user.role == 'admin' || user.role == 'teacher') && confirmation_stage < 2
      if self.update_attribute(:confirmation_stage, confirmation_stage+2)
        if confirmation_stage == 3
          puts "Approved! #{User.find(mentor_id)} is now mentoring #{User.find(mentee_id)}."
        else
          puts "Approved! Now #{User.find(mentee_id)} needs to approve the mentorship and it'll be valid."
        end
      end
      
    end
  end

end
