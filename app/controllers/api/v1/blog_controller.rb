class Api::V1::BlogController < ApplicationController
    before_action :authenticate_user
  
    def index
        user = User.find_by(username: auth_params[:username])
        render json: {
          blog: UserSerializer.new(user),
        }
      end
  
    private
  
  
    def authenticate_user
      decoded_token = decode(request.headers['token'])
      @user = User.find(decoded_token["user_id"])
      render json: { message: 'Un-Authenticated Request', authenticated: false } unless @user
    end
  end
  