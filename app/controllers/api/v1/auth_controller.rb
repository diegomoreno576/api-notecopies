class Api::V1::AuthController < ApplicationController
    def create
      user = User.find_by(username: auth_params[:username])
      
  
      if user && user.authenticate(auth_params[:password])
          payload = {'user_id': user.id}
          token = encode(payload)


          render json: {
              user: UserSerializer.new(user),
              token: token,
              company: user.companies,
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
  
    private
  
    def auth_params
      params.require(:user).permit(:username, :password)
    end
  end