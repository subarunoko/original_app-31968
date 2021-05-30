class Article < ApplicationRecord
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :users, through: :likes
  has_many :like_users, through: :likes, source: :user

  # has_one_attached :image
  has_many :article_tag_relations, dependent: :destroy
  has_many :tags, through: :article_tag_relations, dependent: :destroy

  has_many :comments, dependent: :destroy

  def self.search(search)
    if search != ""
      Article.where('title LIKE(?)', "%#{search}%").order("created_at DESC")
    else
      Article.all.order("created_at DESC")
    end
  end


end
