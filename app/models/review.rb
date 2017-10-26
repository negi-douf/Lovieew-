class Review < ActiveRecord::Base
  validates :title, length: { maximum: 50 }
  validates :object, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 400 }

  has_many :comments, dependent: :destroy
  has_many :nices, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :tags, through: :categories, source: :tag

  belongs_to :user

  accepts_nested_attributes_for :tags, allow_destroy: true, limit: 5

  mount_uploader :picture, PictureUploader
end
