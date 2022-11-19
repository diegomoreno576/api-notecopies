class UserSerializer
    include FastJsonapi::ObjectSerializer
    attributes :id, :email
  
    attribute :chatrooms do |user|
      user.chatrooms.uniq
    end
  end