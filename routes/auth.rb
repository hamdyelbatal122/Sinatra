require 'sinatra'
require_relative '../models/user'

get '/login' do
  erb :login
end

post '/login' do
  user = User.first(username: params[:username])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/'
  else
    @error = 'Invalid username or password.'
    erb :login
  end
end

get '/logout' do
  session.clear
  redirect '/login'
end
