require 'rest_client'
require 'json'
require 'pry'
require 'fileutils'


class GetUserToken
  

  attr_accessor :new_user_info

  def initialize(access_token)
    @access_token = access_token
  end


  def get_user_media_ids
  get_media_url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=#{@access_token}"
  @ids = []

      while get_media_url != nil
        response = RestClient.get(get_media_url)
        json = JSON.parse(response)
        get_media_url = json["pagination"]["next_url"]
        json["data"].each do |item|
          @ids << item["id"]
        end
        # sleep 0.2
      end
    end

  def get_all_likes
    @all_likes = []
    @ids.each do |id|
      user_like_url = "https://api.instagram.com/v1/media/#{id}/likes?access_token=#{@access_token}"
      response = RestClient.get(user_like_url)
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






