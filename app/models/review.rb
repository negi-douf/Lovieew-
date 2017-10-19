class Review < ActiveRecord::Base
  validates :title, length: { maximum: 50 }
  validates :object, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 400 }

  belongs_to :user

  has_many :comments, dependent: :destroy
end
