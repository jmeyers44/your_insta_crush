require_relative 'config/environment'
require 'pry'
require 'net/http'
require 'uri'
require 'sinatra'
require 'omniauth'
require 'omniauth-instagram'

class App < Sinatra::Base
  keys = YAML.load_file('./models/keys.yml')
  use Rack::Session::Cookie
  use OmniAuth::Strategies::Developer
  use OmniAuth::Builder do
  provider :instagram, keys['CLIENT_ID'], keys['CLIENT_SECRET']
  end
 
  configure do
    enable :sessions
  end
   
  helpers do
    def admin?
      session[:admin]
    end
  end
   
  get '/insta_crush' do
    erb :home
  end
   
  get '/private' do
    halt(401,'Not Authorized') unless admin?
    "This is the private page - members only"
  end
   
  get '/new_user' do
    redirect to("/auth/instagram")
  end
   
  get '/logout' do
    session[:admin] = nil
    "You are now logged out"
  end

  get '/auth/instagram/callback' do
    session[:admin] = true
    user_code = env['omniauth.auth']['credentials']['token']
    h = GetUserToken.new(user_code)
    h.get_user_media_ids
    @like_hash = h.get_all_likes
    @photo_count = h.photo_count
    erb :results_page
  end

  get '/auth/failure' do
    params[:message]
  end

  get '/results_page_test' do
    @like_hash = {"Jonathan" => 21, "Jackie" => 13, "Lindsay" => 10}
    @photo_count = 12
    erb :results_page_test
  end
      

  # get '/user/?:code?' do
  #   user_code = params[:code]
  #   h = GetUserToken.new(user_code)
  #   h.get_user_media_ids
  #   @like_hash = h.get_all_likes
  #   @photo_count = h.photo_count
  #   erb :secret_admirer
  # end


end



