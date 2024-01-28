# frozen_string_literal: true

require 'bcrypt'
require 'erb'
require 'sequel'
require 'sinatra'

# require './models/users'

DB = Sequel.sqlite 'db/local.db'

helpers do
  def login?
    return false if session[:username].nil?

    true
  end

  def username
    session[:username]
  end
end

get '/' do
  erb :index
end

get '/signup' do
  erb :signup
end

post '/signup' do
  erb :signup_failed if params[:password] != params[:password_confirm]

  password_salt = BCrypt::Engine.generate_salt
  password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)

  # TODO: normalise this (password table?)
  DB[:users].insert(
    username: params[:username],
    email: params[:email],
    password_salt: password_salt,
    password_hash: password_hash
  )

  session[:username] = params[:username]
  redirect '/'
end

post '/login' do |username, password|
  if userTable.key?(username)
    user = DB[:users].where username: username
    if user[:password_hash] == BCrypt::Engine.hash_secret(password, user[:password_salt])
      session[:username] = username
      redirect '/'
    end
  end
  erb :failed_login
end

get '/logout' do
  session[:username] = nil
  redirect '/'
end
