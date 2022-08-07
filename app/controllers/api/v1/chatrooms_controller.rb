class Api::V1::ChatroomsController < ApplicationController
    before_action :authenticate_user
  
    def index
      chatrooms = @user.chatrooms.uniq
      render json: {
        chatrooms: chatrooms
      }
    end
  
    def create
      @chatroom = @user.chatrooms.new(chatroom_params)
  
      if @chatroom.save
        add_users_to_chatroom
        render json: {
          chatroom: @chatroom,
          users: @chatroom.users
        }
      else
        render json: { message: 'Unable to create chatroom! Please try again.'}
      end
    end
  
    def show
      chatroom = @user.chatrooms.find(params[:id])
      render json: ChatroomSerializer.new(chatroom)
    end
  
    private
  
    def add_users_to_chatroom
      params[:users].each do |name|
        user = User.find_by(username: name)
        (@chatroom.users << user) unless @chatroom.users.include?(user) 
      end
    end
    
    def chatroom_params
      params.require(:chatroom).permit(:title)
    end
  
    def authenticate_user
      decoded_token = decode(request.headers['token'])
      @user = User.find(decoded_token["user_id"])
      render json: { message: 'Un-Authenticated Request', authenticated: false } unless @user
    end
  end
  