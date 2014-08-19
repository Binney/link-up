require 'csv'
namespace :import do
  desc "Import data from CSV files"
  task import_from_csv: :environment do

    n=0
    File.open("public/croydon.csv", "r:ISO-8859-1").readlines.each do |line|
      CSV.parse(line) do |line|
        puts n
        n += 1
        venue_name, event_name, description, day_info, start_t, end_t, age, gender, cost_str, contact, website, addr1, addr2, city, borough, postcode = line
        if addr2.blank?
          address = addr1.to_s+", "+addr2.to_s+", "+borough.to_s+", "+city.to_s
        else
          address = addr1.to_s+", "+borough.to_s+", "+city.to_s
        end
        Venue.create!(name: venue_name.to_s, user_id: 1, description: "Description to follow",
                      street_address: address, postcode: postcode.to_s, gmaps: true) unless Venue.exists?(name: venue_name)

        cost = cost_str.eql?("Free") ? 0 : 1 # TODO Can't do this - search string for numbers using regex
        if gender.eql? "Both"
          gender = "All"
        end

        e = Venue.find_by(name: venue_name).events.create!(name: event_name, 
          description: description.to_s, gmaps: true, cost_details: cost_str.to_s,
           contact: contact.to_s, website: website.to_s, gender: gender.to_s, cost: cost)

        unless start_t.blank? || day_info.blank?
          days = day_info.split(/\W+/) # Splits string into array of days -
          # e.g. "Monday, Tuesday & Thursday" -> ["Monday", "Tuesday", "Thursday"]
          days.each do |day|           
            start_time = Chronic.parse("this "+day+" "+start_t)
            end_time = Chronic.parse("this "+day+" "+end_t)
            day_int = Date::DAYNAMES.index(day)
            e.timings.create!(start_time: start_time, end_time: end_time, day: day_int)
          end
        end

      end
    end
  end
end