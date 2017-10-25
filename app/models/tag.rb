class Tag < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 30 }

  has_many :categories, dependent: :destroy
  has_many :reviews, through: :categories, source: :review
end
