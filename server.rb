# frozen_string_literal: true

require 'sinatra'
require 'sequel'
require 'bcrypt'

# Connect to SQLite database
DB = Sequel.sqlite('db/local.db')

# Create users table if not exists
unless DB.table_exists?(:users)
  DB.create_table :users do
    primary_key :id
    String :username, unique: true
    String :password_hash
  end
end

# Define User model
class User < Sequel::Model
  def password=(password)
    self.password_hash = BCrypt::Password.create(password)
  end

  def authenticate(password)
    BCrypt::Password.new(password_hash) == password
  end
end

# Enable sessions for storing user login state
enable :sessions

# Homepage route
get '/' do
  if session[:user_id]
    # "Welcome, #{User[session[:user_id]].username}! <a href='/logout'>Logout</a>"
    erb :index
  else
    redirect '/login'
  end
end

# Login route
get '/login' do
  erb :login
end

post '/login' do
  user = User.find(username: params[:username])
  if user&.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/'
  else
    'Invalid username or password'
  end
end

# Logout route
get '/logout' do
  session.clear
  redirect '/login'
end

# Signup route
get '/signup' do
  erb :signup
end

post '/signup' do
  user = User.new(username: params[:username], password: params[:password])
  if user.save
    session[:user_id] = user.id
    redirect '/'
  else
    "Error: #{user.errors.full_messages.join(', ')}"
  end
end
