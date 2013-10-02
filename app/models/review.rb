class Review < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :event_id, presence: true

  def approve!
    self.update_attribute(:approved, true)
  end

  def disapprove!
    self.destroy
  end

end
