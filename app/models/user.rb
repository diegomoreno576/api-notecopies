class User < ApplicationRecord
  rolify
    has_secure_password
    has_many :messages, dependent: :destroy
    has_many :chatrooms, through: :messages
    has_many :user_companies
    has_many :companies, through: :user_companies
    has_many :brands

    validates :email, :password, presence: true
    validates :email, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { minimum: 6 }
  

    after_create :assign_default_role, :assign_one_brand

    def assign_default_role
      self.add_role(:customer) if self.roles.blank?
    end

    def assign_one_brand 
     brand = Brand.create(name:"Marca vacía", image:"")
     self.brands << brand 
    end

    def self.find_or_create_with_facebook_access_token(oauth_access_token)
      graph = Koala::Facebook::API.new(oauth_access_token)
      profile = graph.get_object("me", fields: ["name", "email"])
  
      data = {
        name: profile["name"],
        email: profile["email"],
        uid: profile["id"],
        provider: "facebook",
        oauth_token: oauth_access_token,
        picture_url: "https://graph.facebook.com/#{profile['id']}/picture?type=large",
        password: SecureRandom.urlsafe_base64
      }
  
      user = User.find_or_create_by(email: data[:email])
      user.update(data)
      user
    end
  end
  