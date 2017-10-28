class Category < ActiveRecord::Base
  belongs_to :review
  belongs_to :tag

  # 同じ組み合わせが存在しないように
  validates_uniqueness_of :review_id, scope: :tag_id

  # スコープの定義
  scope :between, -> (review_id,tag_id) do
    where("(categories.review_id = ? AND categories.tag_id =?) OR (categories.review_id = ? AND  categories.tag_id =?)", review_id,tag_id, tag_id, review_id)
  end
end
