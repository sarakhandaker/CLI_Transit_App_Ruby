class AddUserToCommutes < ActiveRecord::Migration[5.0]
  def change
        add_column :commutes, :user_id, :integer
  end
end
