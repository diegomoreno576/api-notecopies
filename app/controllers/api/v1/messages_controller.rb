class Api::V1::MessagesController < ApplicationController
    before_action :authenticate_user
  
    def create
      message = @user.messages.new(message_params)
      
      if message.save
        chatroom = message.chatroom
        ChatroomsChannel.broadcast_to(chatroom, {
            chatroom: chatroom,
            users: chatroom.users,
            messages: chatroom.messages
        })
      end
      render json: message
    end
  
    private
  
    def message_params
        params.require(:message).permit(:body, :chatroom_id)
    end
  
    def authenticate_user
      @user = User.find(params[:user_id])
      render json: { message: 'Un-Authenticated Request', authenticated: false } unless @user
    end
  end