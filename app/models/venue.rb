class Venue < ActiveRecord::Base
  has_many :events, dependent: :destroy
  default_scope -> { order('name ASC') }
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 300 }, uniqueness: true
  validates :description, length: { maximum: 5000 }
  acts_as_gmappable
  geocoded_by :gmaps4rails_address
  after_validation :geocode#, :if => :address_changed?

  def gmaps4rails_address
    "#{street_address}, #{postcode}, UK"
  end

end
