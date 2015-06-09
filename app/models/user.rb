class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  serialize :likes
  
  def get_access_token(code)
    message = {
      :client_id => ENV['client_id'], 
      :client_secret => ENV['client_secret'], 
      :grant_type => 'authorization_code', 
      :redirect_uri => ENV['redirect_uri'], 
      :code => "#{code}"
    }
    response = RestClient.post "https://api.instagram.com/oauth/access_token", message
  end

end
