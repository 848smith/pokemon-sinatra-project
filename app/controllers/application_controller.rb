require './config/environment'
require 'pry'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    enable :sessions
    set :session_secret, "pokemoncollector"
    set :views, 'app/views'
  end
  
  get '/' do
    erb :"/users/home"
  end
  
  get '/login' do
    erb :"/user/login"
  end
end