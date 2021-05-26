class LikesController < ApplicationController
  before_action :set_profile, only: [:show]
  before_action :set_article, only:[:create, :destroy, :show]
  # before_action :set_user, except:[:show]
  before_action :authenticate_user!, except:[:show]

  def create
    @like = Like.create(user_id: current_user.id, article_id: params[:id])
    # binding.pry
  end

  def destroy
    @like = Like.find_by(user_id: current_user.id, article_id: params[:id])
    @like.delete
    # binding.pry    
  end

  def show
    @likes = @article.like_users
    # binding.pry
  end

  private

  def set_profile
    @user_prof = current_user
  end

  def set_article
    @article = Article.find(params[:id])
    # binding.pry
  end

  # def set_user
  #   @user = User.find(params[:id])
  #   @profile = @user.profile
  #   # binding.pry
  # end

end
