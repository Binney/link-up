require 'csv'
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
 
    Tag.create!(name: 'sport')
    Tag.create!(name: 'martial arts')
    Tag.create!(name: 'youth club')
    Tag.create!(name: 'football')
    Tag.create!(name: 'rugby')
    Tag.create!(name: 'basketball')
    Tag.create!(name: 'cricket')
    Tag.create!(name: 'dance')
    Tag.create!(name: 'aerobics')
    Tag.create!(name: 'band')
    Tag.create!(name: 'orchestra')
    Tag.create!(name: 'choir')
    Tag.create!(name: 'cooking')
    # ...And so on...

    admin = User.create!(name: "The Flying Spaghetti Monster",
                         email: "fsm@railstutorial.org",
                         password: "foobar",
                         password_confirmation: "foobar",
                         home_address: "1 Kilburn High Road",
                         home_postcode: "",
                         admin: true)
    teacher = User.create!(name: "Dr Jekyll The Maths Teacher",
                         email: "teacher@railstutorial.org",
                         password: "foobar",
                         password_confirmation: "foobar",
                         home_address: "3 Kilburn High Road",
                         home_postcode: "",
                         mentor: true)
    organiser = User.create!(name: "Mr Hyde The Sports Coach",
                         email: "organiser@railstutorial.org",
                         password: "foobar",
                         password_confirmation: "foobar",
                         home_address: "5 Kilburn High Road",
                         home_postcode: "",
                         organiser: true)

    other_venues = Venue.create!(name: "Other Venue",
				 description: "Other venue not listed above", user_id: 0,
                                 postcode: 'W6 7BS', street_address: 'Brook Green', gmaps: true )
    20.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      user = User.create!(name: name, email: email, password: password,
                   password_confirmation: password,
                         home_address: "#{2*n} Kilburn High Road",
                         home_postcode: "")
    end

    File.open("public/societies.csv").readlines.each do |line|
      CSV.parse(line) do |line|
        venue_name, event_name, day, start_t, end_t, gender, cost, contact, website, addr1, addr2, city, borough, postcode, comment, child_tag, parent_tag = line
        if addr2.blank?
          address = addr1.to_s+", "+addr2.to_s+", "+borough.to_s+", "+city.to_s
        else
          address = addr1.to_s+", "+borough.to_s+", "+city.to_s
        end
        Venue.create!(name: venue_name.to_s, user_id: 1, description: "Description to follow", street_address: address, postcode: postcode.to_s, gmaps: true) unless Venue.exists?(name: venue_name)
        Venue.find_by(name: venue_name).events.create!(name: event_name, description: comment.to_s, start_time: Chronic.parse("this "+day.to_s+" "+start_t.to_s), end_time: Chronic.parse("this "+day+" "+end_t), gmaps: true, day: Date::DAYNAMES.index(day), cost: cost.to_s, contact: contact.to_s, website: website.to_s, gender: gender.to_s)
      end
    end
    users = User.all
    users.each { |user| user.diary_entries.create!(name: "Supervisor meeting", start_time: 3.days.from_now.advance(days: rand(-3..10)), repeating: false) }

    users.each do |sender|
      (1..15).each do |recipient|
        sender.messages.create!(receiver_id: recipient, subject: "Hey there "+User.find(recipient).name+"!", message: Faker::Lorem.sentence(6))
      end
    end

    events = Venue.find(2).events
    events.each do |e|
      3.times do |n|
        e.timings.create!(start_time: Chronic.parse(Datetime::DAYNAMES[n]+" 12:30pm"), end_time: Chronic.parse(Datetime::DAYNAMES[n]+" 3pm"))
      end
    end

  end
end
