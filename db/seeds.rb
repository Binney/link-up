# Tags are hard coded because so are the pictures. Adding new tags requires changing code.
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

# Admin is hard coded because one admin is always needed to promote others to admin status.
admin = User.create!(name: "Link Up Admin",
                     email: "admin@link-up.org.uk",
                     password: "foobar",
                     password_confirmation: "foobar",
                     home_address: "10 Downing Street",
                     home_postcode: "SW1A 2AA",
                     role: "admin")