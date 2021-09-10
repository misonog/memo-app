# frozen_string_literal: true

require_relative 'lib/memo'
require './app'

configure :development do
  Memo.connect_db('./config/database.yml')
end

run Sinatra::Application
