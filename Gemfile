source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "bootsnap", require: false
gem "graphiql-rails", group: :development
gem "importmap-rails"
gem "jbuilder"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "redis", "~> 4.0"
gem "sprockets-rails"
gem "pg", "~> 1.4"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem 'devise'
gem 'graphql', '~> 1.13', '>= 1.13.5'
gem 'graphql-pagination'
gem 'search_object', '~> 1.2', '>= 1.2.5'
gem 'search_object_graphql', '0.3.1'
gem 'slim-rails'
gem 'webpacker', '~> 5.x'

group :development, :test do
  gem 'faker'
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails', '~> 6.0.0'
  gem 'factory_bot_rails'
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
