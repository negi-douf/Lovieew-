class Category < ActiveRecord::Base
  belongs_to :review
  belongs_to :tag
end
