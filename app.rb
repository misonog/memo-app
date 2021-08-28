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
  @title = params[:title].to_s
  @content = params[:content]
  @memo = Memo.new(@title, @content)
  if @memo.save
    # TODO: 個別のメモページにリダイレクトするよう修正
    redirect to('/')
  else
    erb :new
  end
end
