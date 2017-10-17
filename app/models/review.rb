class Review < ActiveRecord::Base
  validates :content, presence: true
  validates :object, presence: true
  
  belongs_to :user
end
