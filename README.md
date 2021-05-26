## テーブル設計

## users テーブル

| Column              | Type      | Options                   |
| --------------------| --------- | ------------------------- |
| nickname            | string    | null: false               |
| email               | string    | null: false, unique: true |
| encrypted_password  | string    | null: false               |


## articles テーブル

| Column           | Type         | Options                        |
| ---------------- | ------       | -----------                    |
| title            | string       | null: false                    |
| body             | text         | null: false                    |
| user             | references   | null: false, foreign_key: true |

## Association
- belongs_to :user


## likes テーブル

| Column           | Type         | Options                        |
| ---------------- | ------       | -----------                    |
| user             | references   | null: false, foreign_key: true |
| article          | references   | null: false, foreign_key: true |

## Association
  belongs_to :user
  belongs_to :article


## relationships テーブル

| Column           | Type         | Options                        |
| ---------------- | ------       | -----------                    |
| user             | references   | null: false, foreign_key: true |
| follower         | references   | null: false, foreign_key: true |

## Association
  belongs_to :user
  belongs_to :follower, class_name: 'User'





## delivery_info テーブル

| Column           | Type         | Options                        |
| ---------------- | ------       | -----------                    |
| postal_code      | string       | null: false                    |
| prefecture_id    | integer      | null: false                    |
| city             | string       | null: false                    |
| house_number     | string       | null: false                    |
| building_name    | string       |                                |
| phone_number     | string       | null: false                    |
| order            | references   | null: false, foreign_key: true |

## Association
- belongs_to :order



## profile テーブル
| family_name         | string       | null: false                    |
| first_name          | string       | null: false                    |
| family_name_kana    | string       | null: false                    |
| first_name_kana     | string       | null: false                    |
| birthday            | date         | null: false                    |
| user                | references   | null: false, foreign_key: true |

### Association
- has_many :articles