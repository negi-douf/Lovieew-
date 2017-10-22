class AddIndexToNices < ActiveRecord::Migration
  def change
    add_index :nices, :review_id
    add_index :nices, :user_id
    add_index :nices, [:review_id, :user_id], unique: true
  end
end
