source 'https://rubygems.org'
ruby '2.0.0'
#ruby-gemset=railstutorial_rails_4_0

gem 'rails', '4.0.0'
gem 'bootstrap-sass'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'

group :development, :test do
  gem 'sqlite3', '1.3.7'
  gem 'rspec-rails', '2.13.1'
  # The following optional lines are part of the advanced setup.
  gem 'guard-rspec', '2.5.0'
  gem 'spork-rails', github: 'sporkrb/spork-rails'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.3.9'
end

group :test do
  gem 'selenium-webdriver', '2.0.0'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.2.0'
  gem 'cucumber-rails', '1.3.0', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'

  # Uncomment these lines on Linux.
  gem 'libnotify', '0.8.0'

end

gem 'sass-rails', '4.0.0'
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '1.0.2'
gem 'nested_form'
gem 'cancan'

group :doc do
  gem 'sdoc', '0.3.20', require: false
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor'
  gem 'unicorn'
end

gem 'gmaps4rails', '>= 2.0.0.pre', git: 'https://github.com/fiedl/Google-Maps-for-Rails.git'
gem 'geocoder'

#Below gems included for similarity with sweaton and of unknown purpose?!
gem 'mysql'

gem 'json'

gem 'jquery-ui-rails'
gem 'jquery-ui-sass-rails'

# For uploading images etc
gem 'carrierwave'

# Calendar capability
gem 'ice_cube'
gem "watu_table_builder", :require => "table_builder"

# Search
gem 'ransack'

# Date and time parser for event importing
gem 'chronic'

# Emails
gem 'mandrill-api'
