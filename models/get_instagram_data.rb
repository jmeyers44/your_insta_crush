require 'rest_client'
require 'json'
require 'pry'
require 'fileutils'


class GetUserToken
    
  attr_accessor :new_user_info

  def initialize(user_code)

    form_data = {
      'client_id' => 'YOUR CLIENT ID HERE',
      'client_secret' => 'YOUR CLIENT SECRET HERE',
      'grant_type' => 'authorization_code',
      'redirect_uri' => 'YOUR REDIRECT URI HERE',
      'code' => "#{user_code}"
    }

    uri = URI('https://api.instagram.com/oauth/access_token')
    res = Net::HTTP.post_form(uri, form_data)
    @new_user_info = res.body
    user_info_to_hash = eval(@new_user_info)
    @access_token = user_info_to_hash[:access_token]
  
  end


  def get_user_media_ids
  user_instagram_token = "https://api.instagram.com/v1/users/self/media/recent/?access_token=#{@access_token}"
  @ids = []

      while user_instagram_token != nil
        response = RestClient.get(user_instagram_token)
        json = JSON.parse(response)
        user_instagram_token = json["pagination"]["next_url"]
        
        json["data"].each do |item|
          
          @ids << item["id"]
        end
        sleep 0.2
      end
    end

  def get_all_likes
    @all_likes = []
    @ids.each do |id|
      user_like_token = "https://api.instagram.com/v1/media/#{id}/likes?access_token=#{@access_token}"
      response = RestClient.get(user_like_token)
      json = JSON.parse(response)
      json["data"].each do |item|
          @all_likes << item["username"]
        end
    end
    names = @all_likes
    counts = Hash.new(0)
    names.each { |name| counts[name] += 1 }
    @like_hash = counts.sort_by {|_key, value| value}.reverse
    @like_hash
  end

  def photo_count
    @ids.count
  end

end






