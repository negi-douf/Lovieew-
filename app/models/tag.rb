class Tag < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 30 }
end
