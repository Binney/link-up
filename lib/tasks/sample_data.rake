namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    teacher = User.create!(name: "Dagenham Park CoS Teacher",
                         email: "dagenhampark@link-up.org.uk",
                         password: "foobar",
                         password_confirmation: "foobar",
                         home_address: "School Road, Barking and Dagenham, London, RM10 9QH",
                         school: "Dagenham Park CoS",
                         home_postcode: "",
                         role: "teacher")
    organiser = User.create!(name: "Westminster Academy Teacher",
                         email: "westminsteracademy@link-up.org.uk",
                         password: "foobar",
                         password_confirmation: "foobar",
                         home_address: "The Naim Dangoor Centre, 255 Harrow Road, London, W2 5EZ",
                         school: "Westminster Academy",
                         home_postcode: "",
                         role: "organiser")

    other_venues = Venue.create!(name: "Other Venue",
				 description: "Other venue not listed above", user_id: 0,
                                 postcode: 'Westminster', street_address: '10 Downing Street', gmaps: true )

    postcode_starts = ["RM", "IG", "E", "EC", "N", "W"]
    postcode_max = [20, 11, 18, 4, 22, 14]
    # Create some sample venues
    49.times do |n|
      name = Faker::Company.name+" Youth Club"
      # Postcodes have to be semi-real so they are geocoded properly
      post_nm = rand(6)
      postcode = postcode_starts[post_nm] + postcode_max[post_nm].to_s + " " + 
                  (1+rand(10)).to_s + ('a'..'z').to_a.shuffle[0,2].join.upcase
      description = Faker::Lorem.sentence(5)
      Venue.create!(name: name,
                   description: description,
                   postcode: postcode,
                   is_school: 0,
                   user_id: 1)
    end

    gender_opts = ["Female", "All", "Male"]
    # Create some sample events to go in the sample venues
    99.times do |n|
      name = Faker::Company.catch_phrase+" Club"
      description = Faker::Company.bs
      website = Faker::Internet.url
      gender = gender_opts[rand(2)+rand(2)]
      cost = rand(10)
      cost_details = (cost==0) ? ("Free") : ("£" + cost.to_s)
      event = Venue.find(rand(50)+1).events.create!(name: name,
                                        description: description,
                                        website: website,
                                        gender: gender,
                                        cost: cost,
                                        cost_details: cost_details)
      (rand(3)+1).times do 
        hour = rand(6)+9
        start_time = DateTime.new(2014, 04, rand(8)+1, hour)
        end_time = start_time + rand(2).hours + 30.minutes
        day = start_time.wday
        event.timings.create!(start_time: start_time, end_time: end_time, day: day)
      end

      # Randomly tag each event with between 0 and 2 tags
      rand(3).times do
        event.tagify!(Tag.find(rand(30)+1))
      end

    end
  end
end