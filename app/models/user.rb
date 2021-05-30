class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles

  has_many :likes, dependent: :destroy
  has_many :like_articles, through: :likes, source: :article
  has_many :articles, through: :likes

  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follower

  has_many :passive_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :user

  has_one :profile
  # has_one_attached :image  #<<<<<< imagemagik対応(※画像１枚)

  has_many :comments, dependent: :destroy

  with_options presence: true do
    validates :nickname
    # validates :password,format:{with: /(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{6,}/, message: "英字と数字の両方を含めて設定してください" }
  end

  

  #devise ゲストログイン
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.nickname = 'ゲスト'
      # user.nickname = 'Guest User'
      user.password = SecureRandom.urlsafe_base64
    end
  end


  #devise ユーザー編集
  def update_without_current_password(params, *options)
    params.delete(:current_password)
    # binding.pry
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end


  #ユーザーをフォローする
  def follow(other_user)
    # binding.pry
    unless self == other_user
      self.relationships.find_or_create_by(follower_id: other_user.id)
    end
  end

  #ユーザーのフォローを外す
  def unfollow(other_user)
    relationship = self.relationships.find_by(follower_id: other_user.id)
    relationship.destroy if relationship
  end

  #フォローしていればtrueを返す
  def following?(other_user)
    self.followings.include?(other_user)
    # binding.pry
  end


  # #いいねしていればtrueを返す
  # def like?(user)
  #   self.like_articles.include?(user)
  #   # binding.pry
  # end


end