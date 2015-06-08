class UsersController < ApplicationController
before_action :current_or_guest_user, only: [:new]

  def index
  end

  def new
    redirect_to Instagram.authorize_url(redirect_uri: ENV['redirect_uri'])
  end


  def callback
    user = guest_user
    response = Instagram.get_access_token(params["code"], :redirect_uri => ENV['redirect_uri'])
    user.update(token: response.access_token)
    render action: :loading
  end

  def loading
    @guest_user = guest_user
  end

  def crush
    user = User.find(session[:guest_user_id])
    access_token = user.token
    authorized_user = GetUserInfo.new(access_token)
    user.update(likes: authorized_user.get_all_likes)
    user.update(photo_count: authorized_user.photo_count)
    redirect_to user_path(user.id)
  end

  def show
    if session[:guest_user_id]
      user = User.find(session[:guest_user_id])
      @like_hash = user.likes
      @photo_count = user.photo_count
    else
      redirect_to root_path
    end
  end

end
