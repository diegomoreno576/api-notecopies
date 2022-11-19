class CreateConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :connections do |t|
      t.string :name
      t.string :type
      t.string :picture_url
      t.string :oauth_token
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
