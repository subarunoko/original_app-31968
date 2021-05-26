class RelationshipsController < ApplicationController
  before_action :set_profile, only: [:create, :destroy, :show_following, :show_follower]
  before_action :set_user, only: [:create, :destroy, :show_following, :show_follower]
  
  # def create
  #   # binding.pry
  #   following = current_user.follow(@user)
  #   if following.save
  #     # flash[:success] = "成功"
  #     redirect_to @user
  #   else
  #     # flash[:alert] = "失敗"
  #     redirect_to @user
  #   end
  # end

  # def destroy
  #   following = current_user.unfollow(@user)
  #   # binding.pry
  #   if following.destroy
  #     redirect_to @user
  #   else
  #     redirect_to @user
  #   end
  # end


  def create
    following = current_user.follow(@user)
    # binding.pry
    if following.save
      respond_to do |format|
        # binding.pry
        format.html {redirect_back(fallback_location: root_url)}
        format.js
      end
    else
      redirect_to action: :show_follower
    end
  end

  def destroy
    following = current_user.unfollow(@user)
    # binding.pry
    if following.destroy
      respond_to do |format|
        # binding.pry
        format.html {redirect_back(fallback_location: root_url)}
        format.js
      end
    else
      redirect_to action: :show_follower
    end
  end


  def show_following
    @follows = @user.followings
    # binding.pry

  end

  def show_follower
    @follows = @user.followers
    # binding.pry
    
  end



  private

  def set_profile
    @user_prof = current_user
  end

  def set_user
    # @user = User.find_by(params[:follower_id])
    @user = User.find(params[:id])
    # binding.pry
  end  

end

