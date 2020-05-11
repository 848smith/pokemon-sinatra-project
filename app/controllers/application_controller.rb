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
    erb :"/user/home"
  end
  
  get '/signup' do
    if Helpers.is_logged_in?(session)
      redirect '/home'
    end
    erb :"/user/signup"
  end
  
  post '/signup' do
    if params[:email] == "" || params[:username] == "" || params[:password] == ""
      redirect '/signup'
    end
    if User.all.map{|user| user.email}.include?(params[:email])
      redirect '/signup'
    elsif User.all.map{|user| user.username}.include?(params[:username])
      redirect '/signup'
    end
    user = User.create(:email => params[:email], :username => params[:username], :password => params[:password])
    session[:user_id] = user.id
    redirect '/home'
  end
  
  get '/login' do
    if Helpers.is_logged_in?(session)
      redirect '/home'
    end
    erb :"/user/login"
  end
  
  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/home'
    else
      redirect '/login'
    end
  end
  
  get '/logout' do
    if !Helpers.is_logged_in?(session)
      redirect '/'
    end
    session.clear
    redirect '/'
  end
  
  get '/home' do
    if !Helpers.is_logged_in?(session)
      redirect '/'
    end
    @user = Helpers.current_user(session)
    @pokemons = Pokemon.select{|pokemon| pokemon.user_id == @user.id}
    erb :"/pokemon/index"
  end
  
  get '/pokemon/new' do
    if !Helpers.is_logged_in?(session)
      redirect '/'
    end
    erb :"/pokemon/new"
  end
  
  post '/pokemon' do
    user = Helpers.current_user(session)
    if params[:name].empty? || params[:type].empty? || params[:cp].empty? || params[:fast_move].empty? || params[:power_move].empty? || params[:attack].empty? || params[:defense].empty? || params[:hp].empty?
      redirect '/pokemon/new'
    end
    pokemon = Pokemon.create(:name => params[:name], :type => params[:type], :cp => params[:cp], :user_id => user.id, :fast_move => params[:fast_move], :power_move => params[:power_move], :attack => params[:attack], :defense => params[:defense], :hp => params[:hp])
    redirect '/home'
  end
end