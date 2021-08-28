# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'lib/memo'

get '/' do
  @memos = Memo.all
  erb :index
end
