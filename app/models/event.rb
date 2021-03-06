class Event < ActiveRecord::Base
  belongs_to :venue
  has_many :tags, through: :relationships
  has_many :timings, dependent: :destroy
  accepts_nested_attributes_for :timings, allow_destroy: true
  has_many :favourites, dependent: :destroy
  has_many :relationships, dependent: :destroy

  default_scope -> { order('name ASC') }
  validates :venue_id, presence: true
  validates :name, presence: true, length: { maximum: 300 }
  validates :description, length: { maximum: 5000 }
  acts_as_gmappable
  geocoded_by :gmaps4rails_address
  after_validation :geocode

  def gmaps4rails_address
    "#{venue.gmaps4rails_address}"
  end

  def self.ransackable_attributes(auth_object = nil)
      %w( name description venue_id cost cost_details gender timings ) + _ransackers.keys
  end

  def get_day_info
    arr = []
    self.timings.each do |t|
      arr.push(Date::DAYNAMES[t.start_time.wday]+"s")
    end
    arr.empty? ? "None listed" : arr.to_sentence
  end

  def age_range
    if min_age.blank? || min_age=="0"
      if min_age.blank? || max_age=="0"
        "Any"
      else
        "Maximum #{max_age}"
      end
    else
      if max_age.blank? || max_age=="0"
        "Minimum #{min_age}"
      else
        "#{min_age}-#{max_age}"
      end
    end
  end

  def self.simple_search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end

  def schedule=(new_schedule)
    write_attribute(:schedule, new_schedule.to_hash)
  end

  def schedule
    Schedule.from_hash(read_attribute(:schedule))
  end

  def tagged?(property)
    relationships.find_by(tag_id: property.id)
  end

  def tagify!(property)
    relationships.create!(tag_id: property.id)
  end

  def untagify!(property)
    relationships.find_by(tag_id: property.id).destroy
  end

end
