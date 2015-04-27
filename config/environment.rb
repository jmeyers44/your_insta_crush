ENV['SINATRA_ENV'] ||= "development"

# here we're using bundler to require all of our dependencies in the Gemfile

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

# requiring the app.rb file:
require './app'

require_all 'models'
