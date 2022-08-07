class UserSerializer
    include FastJsonapi::ObjectSerializer
    attributes :id, :username
  
    attribute :chatrooms do |user|
      user.chatrooms.uniq
    end
  end