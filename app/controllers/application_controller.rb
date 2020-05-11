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
  
  get '/signup' do
    if Helpers.is_logged_in?(session)
      redirect '/home'
    end
    erb :"/user/signup"
  end
  
  post 'signup' do
    if params[:email] == "" || params[:username] == "" || params[:password] == ""
      redirect '/signup'
    end
    user = User.create(:email => params[:email], :username => params[:username], :password => params[:password])
    session[:user_id] = user.id
    redirect '/home'
  end
  
  get '/login' do
    erb :"/user/login"
  end
end