require 'csv'
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
 
    Tag.create!(name: 'Art')
    Tag.create!(name: 'Athletics')
    Tag.create!(name: 'Basketball')
    Tag.create!(name: 'Boxing')
    Tag.create!(name: 'Camping')
    Tag.create!(name: 'Cheerleading')
    Tag.create!(name: 'Chess')
    Tag.create!(name: 'Climbing')
    Tag.create!(name: 'Cooking')
    Tag.create!(name: 'Cricket')
    Tag.create!(name: 'Cycling')
    Tag.create!(name: 'Dance')
    Tag.create!(name: 'Duke of Edinburgh')
    Tag.create!(name: 'Fencing')
    Tag.create!(name: 'Football')
    Tag.create!(name: 'Gym')
    Tag.create!(name: 'Homework')
    Tag.create!(name: 'Martial Arts')
    Tag.create!(name: 'Music')
    Tag.create!(name: 'Other')
    Tag.create!(name: 'Photography')
    Tag.create!(name: 'Scouts')
    Tag.create!(name: 'Religion & Spiritual')
    Tag.create!(name: 'Sport')
    Tag.create!(name: 'Swimming')
    Tag.create!(name: 'Tennis')
    Tag.create!(name: 'Theatre')
    Tag.create!(name: 'Tutoring')
    Tag.create!(name: 'Volunteering')
    Tag.create!(name: 'Watersports')
    Tag.create!(name: 'Youth Club')

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
    n=0
    File.open("public/westminster.csv").readlines.each do |line|
      CSV.parse(line) do |line|
        puts n
        n = n+1
        venue_name, event_name, day, start_t, end_t, gender, cost_str, contact, website, addr1, addr2, city, borough, postcode, made_contact, comment, child_tag, parent_tag = line #What the heck is Made_Contact for!?!
        if addr2.blank?
          address = addr1.to_s+", "+addr2.to_s+", "+borough.to_s+", "+city.to_s
        else
          address = addr1.to_s+", "+borough.to_s+", "+city.to_s
        end
        Venue.create!(name: venue_name.to_s, user_id: 1, description: "Description to follow", street_address: address, postcode: postcode.to_s, gmaps: true) unless Venue.exists?(name: venue_name)
        sessionless = false
        if start_t.blank?
          sessionless = true
        else
          start_time = Chronic.parse("this "+day+" "+start_t)
          end_time = Chronic.parse("this "+day+" "+end_t)
        end
        cost = cost_str.eql?("Free") ? 0 : 1 # Can't do this - search string for numbers using regex
        day_int = Date::DAYNAMES.index(day)
        if gender.eql? "Both"
          gender = "All"
        end

        if Event.exists?(name: event_name, venue_id: Venue.find_by(name: venue_name).id)
          Event.find_by(name: event_name, venue_id: Venue.find_by(name: venue_name).id).timings.create!(start_time: start_time, end_time: end_time, day: day_int)
        else
          e = Venue.find_by(name: venue_name).events.create!(name: event_name, description: comment.to_s, gmaps: true, cost_details: cost_str.to_s, contact: contact.to_s, website: website.to_s, gender: gender.to_s, cost: cost)
          e.timings.create!(start_time: start_time, end_time: end_time, day: day_int) unless sessionless == true
          Tag.find(:all, :conditions => ['name LIKE ?', '%#{}%']).each { |t| e.tagify!(t.id) }
        end

      end
    end
    n=0
    File.open("public/dagenham.csv").readlines.each do |line|
      CSV.parse(line) do |line|
        puts "line "+n.to_s
        n = n+1
        venue_name, event_name, day, start_t, end_t, gender, cost_str, contact, website, addr1, addr2, city, borough, postcode, comment, child_tag, parent_tag = line #What the heck is Made_Contact for!?!
        if addr2.blank?
          address = addr1.to_s+", "+addr2.to_s+", "+borough.to_s+", "+city.to_s
        else
          address = addr1.to_s+", "+borough.to_s+", "+city.to_s
        end
        Venue.create!(name: venue_name.to_s, user_id: 1, description: "Description to follow", street_address: address, postcode: postcode.to_s, gmaps: true) unless Venue.exists?(name: venue_name)
        sessionless = false
        if start_t.blank?
          sessionless = true
        else
          start_time = Chronic.parse("this "+day+" "+start_t)
          end_time = Chronic.parse("this "+day+" "+end_t)
        end
        cost = cost_str.eql?("Free") ? 0 : 1 # Can't do this - search string for numbers using regex
        day_int = Date::DAYNAMES.index(day)

        if Event.exists?(name: event_name, venue_id: Venue.find_by(name: venue_name).id)
          Event.find_by(name: event_name, venue_id: Venue.find_by(name: venue_name).id).timings.create!(start_time: start_time, end_time: end_time, day: day_int)
        else
          e = Venue.find_by(name: venue_name).events.create!(name: event_name, description: comment.to_s, gmaps: true, cost_details: cost_str.to_s, contact: contact.to_s, website: website.to_s, gender: gender.to_s, cost: cost)
          e.timings.create!(start_time: start_time, end_time: end_time, day: day_int) unless sessionless == true
        Tag.find(:all, :conditions => ['name LIKE ?', '%#{}%']).each { |t| e.tagify!(t.id) }
        end

      end
    end

    users = User.all
    users.each { |user| user.diary_entries.create!(name: "Supervisor meeting", start_time: 3.days.from_now.advance(days: rand(-3..10))) }

    users.each do |sender|
      (1..15).each do |recipient|
        sender.messages.create!(receiver_id: recipient, subject: "Hey there "+User.find(recipient).name+"!", message: Faker::Lorem.sentence(6))
      end
    end

  end
end
