class Mentorship < ActiveRecord::Base
  belongs_to :mentor, class_name: "User"
  belongs_to :mentee, class_name: "User"
  validates :mentor_id, presence: true
  validates :mentee_id, presence: true
end
