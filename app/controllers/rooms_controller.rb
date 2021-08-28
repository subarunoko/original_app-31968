class RoomsController < ApplicationController
  before_action :set_room, only: [:show]
  before_action :set_profile, only: [:index,:show]
  before_action :authenticate_user!, only: [:index,:show]
  before_action :contributor_confirmation, only: [:show]

  def index
    @user = User.find(current_user.id)
    # @entries = @user.entries
    rooms = current_user.entries.pluck(:room_id)
    # # user_idがチャット相手のidが一致するものと、
    # # room_idが上記roomsのどれかに一致するレコードを取得
    @entries = Entry.where(room_id: rooms).where.not(user_id: @user.id).order(created_at: :desc)  
  end

  def show
    # @room = Room.find(params[:id])
    entry_user = Entry.where(room_id: @room.id).where.not(user_id: current_user.id)   
    @user = User.find(entry_user[0][:user_id])
    # 投稿一覧表示に利用
    @chats = @room.chats
    # メッセージ投稿に利用
    # @chat = current_user.chats.build
  end


  private

  def set_profile
    @user_prof = current_user
  end

  def set_room
    @room = Room.find_by(id: params[:id])
  end

  def room_params
    params.require(:room).merge(user_id: current_user.id)
  end

  def contributor_confirmation
    if @room.present?
      entry = Entry.where(room_id: @room.id).where(user_id: current_user.id)
      # binding.pry
      if entry == []
        redirect_to root_path and return
      end
    else
      redirect_to root_path and return
    end
  end

end
