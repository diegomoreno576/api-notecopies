class CompannySerializer
    include FastJsonapi::ObjectSerializer
    attributes :id, :code, :name
    
    attribute :companies do |user|   
        UserSerializer.new(user.companies)
      end
  end