class AddUserFacebookAuthenticate < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :picture_url, :string
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :oauth_token, :string
  end
end
