require_relative 'config/environment'
require 'pry'
require 'net/http'
require 'uri'

class App < Sinatra::Base

  
  get '/insta_crush' do
    erb :home
  end
  
  get '/new_user' do
    redirect to('https://api.instagram.com/oauth/authorize/?client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URI&response_type=code')    
  
  end

  get '/user/?:code?' do
    user_code = params[:code]
    h = GetUserToken.new(user_code)
    h.get_user_media_ids
    @like_hash = h.get_all_likes
    @photo_count = h.photo_count
    erb :secret_admirer
  end


end



