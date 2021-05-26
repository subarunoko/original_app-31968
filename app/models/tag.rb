class Tag < ApplicationRecord
  has_many :article_tag_relations, dependent: :destroy, foreign_key: :tag_id
  has_many :articles, through: :article_tag_relations

  validates :name, uniqueness: true
end
