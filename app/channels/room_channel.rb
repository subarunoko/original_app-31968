class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "room_channel"
    stream_from "room_channel_#{params['room']}"    # ここ重要ポイント
    stream_for current_user.id
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # jsで実行されたspeakのmessageを受け取り、room_channelのreceivedにブロードキャストする
    # Chat.create! content: data['chat'], user_id: current_user.id, room_id: params['room']
    chat = Chat.create(content: data['chat'], user_id: current_user.id, room_id: params['room'])
    
    # binding.pry
    # ActionCable.server.broadcast "room_channel_#{chat.room_id}", chat: render_chat(chat), current_user: current_user, send_user: chat.user.id
    # ActionCable.server.broadcast "room_channel_#{chat.room_id}", chat: render_chat(chat), current_user: current_user, send_user: chat.user.id
    create_time = chat.created_at
    create_time = create_time.strftime("%H:%M") 
    # ActionCable.server.broadcast "room_channel_#{chat.room_id}", chat: data['chat'], current_user: current_user.id, send_user: chat.user.id, create_time: create_time, isCurrent_user: true
    ActionCable.server.broadcast "room_channel_#{chat.room_id}", chat: data['chat'], current_user: current_user.id, send_user: chat.user.id, create_time: create_time, isCurrent_user: false

    
    # RoomChannel.broadcast_to("room_channel_#{chat.room_id}", chat: data['chat'], current_user: current_user.id, create_time: create_time, isCurrent_user: true)
    # RoomChannel.broadcast_to("room_channel_#{chat.room_id}", chat: data['chat'], current_user: current_user.id, create_time: create_time, isCurrent_user: false)

  end

  private
  # def render_chat(chat)
  #   ApplicationController.renderer.render partial: 'chats/chat', locals: { chat: chat, current_user: chat.user }
  # end

end