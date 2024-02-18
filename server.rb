# frozen_string_literal: true

require 'sinatra'
require 'sequel'
require 'bcrypt'

# local SQLite database within project directory
DB = Sequel.sqlite('db/local.db')

# base user model inherits from Sequel::Model
# - serialize to database
# - creates `initialize` method automatically using database fields
class User < Sequel::Model
  def password=(password)
    self.password = BCrypt::Password.create(password)
  end

  def authenticate(password)
    BCrypt::Password.new(password_hash) == password
  end
end

# enable sessions to keep user logged in during their visit
# this creates a `session` table storing currently active users
enable :sessions

get '/' do
  if session[:user_id]
    erb :index
  else
    redirect '/login'
  end
end

get '/login' do
  erb :login
end

post '/login' do
  user = User.find(username: params[:username])
  if user&.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/'
  else
    erb :login_err
  end
end

get '/logout' do
  session.clear
  redirect '/login'
end

get '/signup' do
  erb :signup
end

post '/signup' do
  user = User.new(username: params[:username], password: params[:password])
  if user.save
    session[:user_id] = user.id
    redirect '/'
  else
    erb :signup_err
  end
end
