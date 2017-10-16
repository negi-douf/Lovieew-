class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :title
      t.string :content
      t.string :object
      t.string :picture
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
