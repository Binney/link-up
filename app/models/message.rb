class Message < ActiveRecord::Base
  belongs_to :receiver, class_name: "User"
  belongs_to :sender, class_name: "User"
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :subject, length: { maximum: 200 }
  validates :message, length: { maximum: 5000 }
  self.per_page = 10

  def read!
    self.unread = false
  end

end
