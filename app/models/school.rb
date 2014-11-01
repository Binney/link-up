class School < ActiveRecord::Base
  belongs_to :venue
  has_many :users
  has_many :logbook_templates

  validates :teacher_code, presence: true, length: {minimum: 5}
  validates :mentor_code, presence: true, length: {minimum: 5}
  validates :student_code, presence: true, length: {minimum: 5}

  def name
  	(self.id == 1) ? "No school" : self.venue.name
  end

end
