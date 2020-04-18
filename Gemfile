# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# gem "rails"
gem 'activesupport'
gem 'redis'

group :development, :test do
  gem 'rubocop'
  gem 'cucumber'
  gem 'i18n'
  gem 'dotenv'
  gem 'rspec'
  gem 'aruba'
end

group :development do
  gem 'guard'
  gem 'guard-compat'
  gem 'guard-cucumber'
end