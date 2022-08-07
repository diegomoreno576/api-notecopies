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
      decoded_jwt = decode(request.headers['jwt'])
      @user = User.find(decoded_jwt["user_id"])
      render json: { message: 'Un-Authenticated Request', authenticated: false } unless @user
    end
  end
  