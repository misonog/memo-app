# frozen_string_literal: true

require 'sinatra'

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

get '/memos/:id/edit' do
  @memo = Memo.find_by_id(params[:id].to_i)
  erb :edit
end

patch '/memos/:id' do
  @memo = Memo.find_by_id(params[:id].to_i)
  if @memo.update(title: params[:title], content: params[:content])
    redirect to("/memos/#{@memo.id}")
  else
    erb :edit
  end
end

delete '/memos/:id' do
  Memo.find_by_id(params[:id].to_i).destroy
  redirect to('/')
end

not_found do
  '404 not found'
end
