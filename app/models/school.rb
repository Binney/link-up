class School < ActiveRecord::Base
  belongs_to :venue

  def name
  	self.venue.name
  end

end
