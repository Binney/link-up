class Timing < ActiveRecord::Base
  belongs_to :event
  default_scope -> { order('start_time ASC') }
  validates :start_time, presence: true
end
