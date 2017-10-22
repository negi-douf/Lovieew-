class Review < ActiveRecord::Base
  validates :title, length: { maximum: 50 }
  validates :object, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 400 }

  has_many :comments, dependent: :destroy
  has_many :nices, dependent: :destroy

  belongs_to :user

  mount_uploader :picture, PictureUploader
end
