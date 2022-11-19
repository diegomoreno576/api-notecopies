class Api::V1::AuthController < ApplicationController
  def create
    user = User.find_by(username: auth_params[:username])

    if user && user.authenticate(auth_params[:password])
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
      render json: {
          message: 'This username/password combination cannot be found',
          authenticated: false
      }
    end
  end

  def create_facebook_user
    facebook_access_token = params.require(:facebook_access_token)
    user = User.find_or_create_with_facebook_access_token(facebook_access_token)
    payload = {'user_id': user.id}
    token = encode(payload)
    
    if user.persisted?
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

  def delete_sesion_jwt
    decoded_token = decode(request.headers['token'])
    @user = User.find(decoded_token["user_id"])
    @user.update(token: nil)
    render json: {message: 'Session deleted'}
  end

  private

  def auth_params
    params.require(:user).permit(:username, :password)
  end
end