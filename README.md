## テーブル設計

## users テーブル

| Column              | Type      | Options                   |
| --------------------| --------- | ------------------------- |
| nickname            | string    | null: false               |
| email               | string    | null: false, unique: true |
| encrypted_password  | string    | null: false               |

## Association
  has_many :articles
  has_many :likes, dependent: :destroy
  has_many :like_articles, through: :likes, source: :article
  has_many :articles, through: :likes
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follower
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :user
  has_one :profile


## articles テーブル

| Column           | Type         | Options                        |
| ---------------- | ------       | -----------                    |
| title            | string       | null: false                    |
| body             | text         | null: false                    |
| user             | references   | null: false, foreign_key: true |

## Association
- belongs_to :user
  has_many :likes
  has_many :users, through: :likes
  has_many :like_users, through: :likes, source: :user
  has_many :article_tag_relations, dependent: :destroy
  has_many :tags, through: :article_tag_relations, dependent: :destroy


## likes テーブル

| Column          | Type         | Options                        |
| --------------- | ------       | -----------                    |
| user            | references   | null: false, foreign_key: true |
| article         | references   | null: false, foreign_key: true |

## Association
  belongs_to :user
  belongs_to :article


## relationships テーブル

| Column          | Type         | Options                        |
| --------------- | ------       | -----------                    |
| user            | references   | null: false, foreign_key: true |
| follower        | references   | null: false, foreign_key: true |

## Association
  belongs_to :user
  belongs_to :follower, class_name: 'User'


## profiles テーブル

| Column          | Type         | Options                        |
| --------------- | ------       | -----------                    |
| language_id     | string       | null: false                    |
| description     | string       |                                |
| user            | references   | null: false, foreign_key: true |

### Association
- has_one :user


## tags テーブル

| Column          | Type         | Options                        |
| --------------- | ------       | -----------                    |
| name            | string       | null: false                    |

## Association
  has_many :article_tag_relations
  has_many :article_tag_relations, dependent: :destroy, foreign_key: :tag_id
  has_many :articles, through: :article_tag_relations