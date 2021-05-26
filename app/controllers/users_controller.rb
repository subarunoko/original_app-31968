class UsersController < ApplicationController
  before_action :set_profile, only: [:index, :show, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authenticate_user!, except: [:show]
  before_action :contributor_confirmation, only: [:edit, :update, :destroy]

  def index
  end

  def show
    # @nickname = @user.nickname
    # binding.pry
    @article = Article.where(user_id: params[:id])
    @like = Like.where(user_id: params[:id])

    # binding.pry
    # if user_signed_in?
    #   @user = User.find(params[:id])
    #   @profile = @user.profile
    # end
    
  end

  def edit
  end

  def update
    if @profile.update(update_params)
      redirect_to action: :show   # "保存成功" 完了ページへ戻る
    else
      render :edit
    end
  end

  private

  def set_profile
    @user_prof = current_user
  end

  def set_user
    @user = User.find(params[:id])
    @profile = @user.profile
    # binding.pry
  end

  def contributor_confirmation
    if current_user != @user
      redirect_to root_path and return
    end
  end

  def update_params
    params.require(:profile).permit(:language_id, :description, :image).merge(user_id: current_user.id)
  end

end
