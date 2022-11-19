class Api::V1::UsersController < ApplicationController
    before_action :authenticate_user, only: :index 
  
    def index
      users = User.all 
      render json: users
    end

    def current_user
      decoded_token = decode(request.headers['token'])
      @user = User.find(decoded_token["user_id"])
      render json: {
        user: UserSerializer.new(@user),
        brands: @user.brands,
        roles: @user.roles,
        authenticated: true,
        token: request.headers['token'],
        
      }
    end

    def current_user_brand 
      decoded_token = decode(request.headers['token'])
      @user = User.find(decoded_token["user_id"])
      @brand = Brand.find(params[:id])
      render json: {
        user: UserSerializer.new(@user),
        brand: @brand,
        roles: @user.roles,
        authenticated: true,
        token: request.headers['token'],

      }
    end
    
    
    def create
      user = User.new(user_params)
  
      if user.save
        payload = {'user_id': user.id}
        token = encode(payload)
        render json: {
          user: UserSerializer.new(user),
              token: token,
              brands: user.brands,
              roles: user.roles,
              authenticated: true
             }
      else
        render json: { message: 'There was an error creating your account' }
      end
    end

      def create_facebook_user
      facebook_access_token = params.require(:facebook_access_token)
      user = User.find_or_create_with_facebook_access_token(facebook_access_token)
  
      if user.persisted?
        payload = {'user_id': user.id}
        token = encode(payload)
        render json: {
          user: UserSerializer.new(user),
              token: token,
              brands: user.brands,
              roles: user.roles,
              authenticated: true
             }
      else
        render json: user.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  
    def authenticate_user
      decoded_token = decode(request.headers['token'])
      @user = User.find(decoded_token["user_id"])
      render json: { message: 'Un-Authenticated Request', authenticated: false } unless @user
    end

  
  end
  
  