class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :content, presence: true
  
  # createの後にコミットする { MessageBroadcastJobのperformを遅延実行 引数はself }
  # 投稿されたメッセージをメッセージ用の部分テンプレートでHTMLに変換
  # after_create_commit { MessageBroadcastJob.perform_later self }

end
