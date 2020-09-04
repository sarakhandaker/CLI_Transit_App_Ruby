class AddNameToCommutes < ActiveRecord::Migration[5.0]
  def change
    add_column :commutes, :name, :string
  end
end
