class ChangeContentToReviews < ActiveRecord::Migration
  def change
    change_column :reviews, :content, :text, null: false
  end
end
