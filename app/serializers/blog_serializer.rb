class BlogSerializer
    include FastJsonapi::ObjectSerializer
    attributes :id, :code, :name
    
    attribute :blogs do |user|   
        UserSerializer.new(user.blogs)
      end
  end