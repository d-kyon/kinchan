class AddLineToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :nonce, :string,default: "", null: false
    add_column :users, :line_user_id, :string,default: "", null: false
  end
end
