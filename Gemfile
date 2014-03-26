source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.3'
gem 'bootstrap-sass', '2.3.2.0'
gem 'sprockets', '2.11.0'
gem 'bcrypt-ruby', '3.1.2'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '2.13.1'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.2.0'
  gem 'cucumber-rails', '1.4.0', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'

end

gem 'sass-rails', '~> 4.0.2'
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.1'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '1.0.2'
gem 'nested_form'
gem 'cancan'

gem 'gmaps4rails', '>= 2.0.0.pre', git: 'https://github.com/fiedl/Google-Maps-for-Rails.git'
gem 'geocoder'

gem 'json'

gem 'jquery-ui-rails'
gem 'jquery-ui-sass-rails'

gem 'carrierwave'
gem 'ice_cube'
gem "watu_table_builder", :require => "table_builder"
gem 'ransack'
gem 'chronic'
gem 'mandrill-api'

group :doc do
  gem 'sdoc', '0.3.20', require: false
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor'
end

platforms :ruby do
  gem 'unicorn'
end

platforms :mswin do
  gem 'thin'
end