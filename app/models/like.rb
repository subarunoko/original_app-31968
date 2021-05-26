class Like < ApplicationRecord
  belongs_to :user
  belongs_to :article


  #いいねする
  def like(article)
    likes.create(article_id: article.id)
    # binding.pry
  end

  #いいねを外す
  def unlike(article)
    likes.find_by(article_id: article.id).destroy
  end

  # #いいねしていればtrueを返す
  # def like?(article)
  #   like_articles.include?(article)
  #   binding.pry
  # end

end