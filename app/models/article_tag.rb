class ArticleTag

  include ActiveModel::Model
  attr_accessor :title, :body, :name, :article_id, :tag_ids, :user_id

  with_options presence: true do
    validates :title, length: { maximum: 30, message: "の文字数の上限を超えてます\n修正して下さい" }
    validates :body, length: { maximum: 2000, message: "の文字数の上限を超えてます\n修正して下さい" }
    validates :tag_ids
  end

  validate :tag_length
  validate :tag_content_kigou


  def save
    @article = Article.create(title: title, body: body, user_id: user_id)
    tag_list = tag_ids.split(" ")
    # binding.pry
    tag_list.each do |tag_name|
      @tag = Tag.where(name: tag_name).first_or_initialize
      @tag.save
      unless ArticleTagRelation.where(article_id: @article.id, tag_id: @tag.id).exists?
        ArticleTagRelation.create(article_id: @article.id, tag_id: @tag.id)
      end
    end
  end

  def update(current_tags)
    @article = Article.where(id: article_id)
    article = @article.update(title: title, body: body, user_id: user_id)
    tag_lists = tag_ids.split(" ")

    old_tags = current_tags - tag_lists
    new_tags = tag_lists - current_tags
    # binding.pry
    unless old_tags == []
      old_tags.each do |old_tag|
        @old_tag = Tag.where(name: old_tag)
        map = ArticleTagRelation.where(tag_id: @old_tag[0].id)
        ArticleTagRelation.find(map[0][:id]).delete
      end
    end

    unless new_tags == []
      new_tags.each do |new_tag|
        @new_tag = Tag.where(name: new_tag).first_or_initialize
        @new_tag.save
        unless ArticleTagRelation.where(article_id: @article[0].id, tag_id: @new_tag.id).exists?
          ArticleTagRelation.create(article_id: @article[0].id, tag_id: @new_tag.id)
        end
      end
    end
  end


  private

  def tag_length
    tag_list = tag_ids.split(" ")
    errors.add(:tag_ids,  "のタグ数の上限を超えてます\n修正して下さい" ) if tag_list.length >= 6
  end

  def tag_content_kigou
    tag_list = tag_ids
    errors.add(:tag_ids,  "　カンマは使用できません\n半角スペースへ修正して下さい" ) if tag_list.include?(",")
    errors.add(:tag_ids,  "　ピリオドは使用できません\n半角スペースへ修正して下さい" ) if tag_list.include?(".")
    errors.add(:tag_ids,  "　ハイフンは使用できません\n半角スペースへ修正して下さい" ) if tag_list.include?("-")
    errors.add(:tag_ids,  "　読点は使用できません\n半角スペースへ修正して下さい" ) if tag_list.include?("、")
    errors.add(:tag_ids,  "　句点は使用できません\n半角スペースへ修正して下さい" ) if tag_list.include?("。")
    errors.add(:tag_ids,  "　全角スペースは使用できません\n半角スペースへ修正して下さい" ) if tag_list.include?("　")
  end

end