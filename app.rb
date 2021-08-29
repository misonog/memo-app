# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  @memos = Memo.all
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  @memo = Memo.new(title: params[:title], content: params[:content])
  if @memo.save
    redirect to("/memos/#{@memo.id}")
  else
    erb :new
  end
end

get '/memos/:id' do
  @memo = Memo.find_by_id(params[:id].to_i)
  erb :show
end
