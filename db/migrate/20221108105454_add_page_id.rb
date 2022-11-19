class AddPageId < ActiveRecord::Migration[7.0]
  def change
    add_column :connections, :page_id, :bigint
    add_column :connections, :page_type, :string
  end
end
