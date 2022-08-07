
class ApplicationController < ActionController::API
  
    def encode(payload)
      JsonWebToken.encode(payload)
    end
  
    def decode(token)
      JsonWebToken.decode(token)
    end
  
    def frontend_path
      render file: 'public/index.html'
    end
  end
  