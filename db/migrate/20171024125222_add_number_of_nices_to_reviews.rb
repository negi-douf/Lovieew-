class AddNumberOfNicesToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :number_of_nices, :integer, default: 0
  end
end
