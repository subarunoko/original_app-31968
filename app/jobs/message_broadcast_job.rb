class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat)
    # ActionCable.server.broadcast "room_channel_#{chat.room_id}", chat: render_chat(chat)
    # ActionCable.server.broadcast "room_channel_#{chat.room_id}", chat: render_chat(chat), current_user: chat.user
  end

  private

  def render_chat(chat)
    # ApplicationController.renderer.render partial: 'chats/chat', locals: { chat: chat }
    ApplicationController.renderer.render partial: 'chats/chat', locals: { chat: chat, current_user: chat.user }
  end
end
