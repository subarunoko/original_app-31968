class Profile < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :image  #<<<<<< imagemagik対応(※画像１枚)

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :language

  # with_options presence: true do
  #   validates :description , length: { maximum: 250, message: "の文字数の上限が250文字を超えてます" }
  # end

  validates :description , length: { maximum: 250, message: "が文字数の上限を超えてます" }

  with_options numericality: { other_than: 0, message: "が未選択です"} do |i|
    i.validates :language_id
  end


  #devise ゲストログイン
  def self.guest(user)
    create(language_id: 16) do |profile|
      profile.description = 'hello world'
      profile.user_id = user.id
    end
  end

end
