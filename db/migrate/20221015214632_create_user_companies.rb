class CreateUserCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :user_companies do |t|
      t.integer :user_id
      t.integer :company_id

      t.timestamps
    end
  end
end
