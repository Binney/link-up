require 'csv'
namespace :import do
  desc "Import data from CSV files"
  task import_from_csv: :environment do

    n=0
    File.open("public/westminster.csv").readlines.each do |line|
      CSV.parse(line) do |line|
        puts n
        n = n+1
        venue_name, event_name, day, start_t, end_t, gender, cost_str, contact, website, addr1, addr2, city, borough, postcode, made_contact, comment, child_tag, parent_tag = line
        if addr2.blank?
          address = addr1.to_s+", "+addr2.to_s+", "+borough.to_s+", "+city.to_s
        else
          address = addr1.to_s+", "+borough.to_s+", "+city.to_s
        end
        Venue.create!(name: venue_name.to_s, user_id: 1, description: "Description to follow",
                      street_address: address, postcode: postcode.to_s, gmaps: true) unless Venue.exists?(name: venue_name)
        sessionless = false
        if start_t.blank?
          sessionless = true
        else
          start_time = Chronic.parse("this "+day+" "+start_t)
          end_time = Chronic.parse("this "+day+" "+end_t)
        end
        cost = cost_str.eql?("Free") ? 0 : 1 # TODO Can't do this - search string for numbers using regex
        day_int = Date::DAYNAMES.index(day)
        if gender.eql? "Both"
          gender = "All"
        end

        if Event.exists?(name: event_name, venue_id: Venue.find_by(name: venue_name).id)
          Event.find_by(name: event_name, venue_id: Venue.find_by(name: venue_name).id).timings.create!(
              start_time: start_time, end_time: end_time, day: day_int)
        else
          e = Venue.find_by(name: venue_name).events.create!(name: event_name, 
            description: comment.to_s, gmaps: true, cost_details: cost_str.to_s,
             contact: contact.to_s, website: website.to_s, gender: gender.to_s, cost: cost)
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
        venue_name, event_name, day, start_t, end_t, gender, cost_str, contact, website, addr1, addr2, city, borough, postcode, comment, child_tag, parent_tag = line
        if addr2.blank?
          address = addr1.to_s+", "+addr2.to_s+", "+borough.to_s+", "+city.to_s
        else
          address = addr1.to_s+", "+borough.to_s+", "+city.to_s
        end
        if venue_name.blank?
          venue_name = "Other Venue"
        end
        Venue.create!(name: venue_name.to_s, user_id: 1, description: "Description to follow",
            street_address: address, postcode: postcode.to_s, gmaps: true) unless Venue.exists?(name: venue_name)
        sessionless = false
        if start_t.blank?
          sessionless = true
        else
          start_time = Chronic.parse("this "+day+" "+start_t)
          end_time = Chronic.parse("this "+day+" "+end_t)
        end
        cost = cost_str.eql?("Free") ? 0 : 1 # TODO Can't do this - search string for numbers using regex
        day_int = Date::DAYNAMES.index(day)

        if Event.exists?(name: event_name, venue_id: Venue.find_by(name: venue_name).id)
          Event.find_by(name: event_name, venue_id: Venue.find_by(name: venue_name).id).timings.create!(start_time: start_time, end_time: end_time, day: day_int)
        else
          e = Venue.find_by(name: venue_name).events.create!(name: event_name[0..240], 
            description: comment.to_s[0..240], gmaps: true, cost_details: cost_str.to_s,
             contact: contact.to_s, website: website.to_s, gender: gender.to_s, cost: cost)
          e.timings.create!(start_time: start_time, end_time: end_time, day: day_int) unless sessionless == true
        end

      end
    end
  end
end