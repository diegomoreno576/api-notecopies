class JsonWebToken
    class << self
      SECRET_KEY = 'ENV[“API_KEY”]'
      def encode(payload, exp = 24.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, SECRET_KEY)
      end
   
      def decode(jwt)
        body = JWT.decode(jwt, SECRET_KEY)[0]
        HashWithIndifferentAccess.new body
      rescue
        nil
      end
    end
  end