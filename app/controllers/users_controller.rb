class UsersController < ApplicationController
  before_action :set_profile, only: [:index, :show, :edit, :update]
  before_action :judge_follow, only: [:show]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authenticate_user!, except: [:show]
  before_action :contributor_confirmation, only: [:edit, :update, :destroy]

  def index
  end

  def show
    @article = Article.where(user_id: params[:id])
    # @article = @user.articles
    @comment = @user.comments 
    @like = Like.where(user_id: params[:id])
    
    if user_signed_in?
      # どのユーザーとチャットするかを取得。
      @user = User.find(params[:id])
      rooms = current_user.entries.pluck(:room_id)
      # user_idがチャット相手のidが一致するものと、
      # room_idが上記roomsのどれかに一致するレコードを取得
      @entry = Entry.find_by(user_id: @user.id, room_id: rooms)

      # 相互フォロー判定
      if @following_user.present? && @follower_user.present?
      # binding.pry
        if @entry.nil?
          @room = Room.create
          # entryをカレントユーザー分とチャット相手分を作る
          Entry.create(user_id: current_user.id, room_id: @room.id)
          Entry.create(user_id: @user.id, room_id: @room.id)
        else
          @room = @entry.room
        end
      end
      # binding.pry
    end
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

  def judge_follow
    if user_signed_in?
      @following_user = Relationship.find_by(user_id: current_user.id, follower_id: params[:id])
      @follower_user = Relationship.find_by(user_id: params[:id], follower_id: current_user.id)
    end
  end

  # def judge_room
  #   if user_signed_in?
  #     @following_user = Relationship.find_by(user_id: current_user.id, follower_id: params[:id])
  #     @follower_user = Relationship.find_by(user_id: params[:id], follower_id: current_user.id)
  #   end
  # end

  def update_params
    params.require(:profile).permit(:language_id, :description, :image).merge(user_id: current_user.id)
  end

end
