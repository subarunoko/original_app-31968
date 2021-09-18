require 'rails_helper'

RSpec.describe "チャット機能", js: true, type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @user3 = FactoryBot.create(:user)
    @profile1 = FactoryBot.create(:profile, user_id: @user1.id)
    @profile2 = FactoryBot.create(:profile, user_id: @user2.id)
    @profile3 = FactoryBot.create(:profile, user_id: @user3.id)
    @article1 = FactoryBot.create(:article1, user_id: @user1.id)
    @article2 = FactoryBot.create(:article2, user_id: @user2.id)
    @tag1 = FactoryBot.create(:tag)
    ArticleTagRelation.create(article_id: @article1.id, tag_id: @tag1.id)
    ArticleTagRelation.create(article_id: @article2.id, tag_id: @tag1.id)
    @comment1 = FactoryBot.create(:comment1, user_id: @user1.id, article_id: @article2.id)
    @comment2 = FactoryBot.create(:comment2, user_id: @user3.id, article_id: @article2.id)
    Relationship.create(user_id: @user1.id, follower_id: @user2.id)
    Relationship.create(user_id: @user2.id, follower_id: @user1.id)
    @room1 = FactoryBot.create(:room1)
    @room2 = FactoryBot.create(:room2)
    Entry.create(user_id: @user1.id, room_id: @room1.id)
    Entry.create(user_id: @user2.id, room_id: @room1.id)
    @chat1 = FactoryBot.build(:chat1, user_id: @user1.id, room_id: @room1.id)
    @chat2 = FactoryBot.build(:chat2, user_id: @user2.id, room_id: @room2.id)
  end

  context "チャットできる時" do
    it "ログインしたらチャットできる" do
      # トップページに移動する
      visit root_path

      # ユーザー1でログインする
      sign_in(@user1)

      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path

      # 記事2の投稿者のページへ遷移する
      click_on "#{@article2.user.nickname}"
      sleep 0.5
      # 記事2の投稿者のページへ遷移することを確認する
      expect(current_path).to eq user_path(@article2.user)
      sleep 0.5

      click_on "チャットへGo"

      # チャットページへ遷移することを確認する
      expect(current_path).to eq room_path(@room1)

      # チャット入力する
      fill_in "chat-sentence", with: "user1からuser2へチャット送信テストです"

      # 送信する
      find("#chat-send-button").click
      sleep 0.5
      # 送信したことを確認する
      expect(page).to have_content("user1からuser2へチャット送信テストです")

      # トップページに移動する
      visit root_path
      click_on "ログアウト"

      # ユーザー2でログインする
      sign_in(@user2)

      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path

      # 記事1の投稿者のページへ遷移する
      click_on "#{@article1.user.nickname}"
      sleep 0.5
      # 記事1の投稿者のページへ遷移することを確認する
      expect(current_path).to eq user_path(@article1.user)
      sleep 0.5

      click_on "チャットへGo"

      # チャットページへ遷移することを確認する
      expect(current_path).to eq room_path(@room1)

      # チャット受信したことを確認する
      expect(page).to have_content("user1からuser2へチャット送信テストです")

      # チャット入力する
      fill_in "chat-sentence", with: "user2からuser1へチャット送信テストです"

      # 送信する
      find("#chat-send-button").click
      sleep 0.5
      # 送信したことを確認する
      expect(page).to have_content("user2からuser1へチャット送信テストです")

      # トップページに移動する
      visit root_path
      click_on "ログアウト"

      # ユーザー1でログインする
      sign_in(@user1)

      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path

      # 記事2の投稿者のページへ遷移する
      click_on "#{@article2.user.nickname}"
      sleep 0.5
      # 記事2の投稿者のページへ遷移することを確認する
      expect(current_path).to eq user_path(@article2.user)
      sleep 0.5

      click_on "チャットへGo"

      # チャットページへ遷移することを確認する
      expect(current_path).to eq room_path(@room1)

      # チャット受信したことを確認する
      expect(page).to have_content("user2からuser1へチャット送信テストです")
    end
  end

  context "チャットできない時" do
    it "ログインしていないとチャットできない" do
      # トップページに移動する
      visit root_path

      # 記事2の投稿者のページへ遷移する
      click_on "#{@article2.user.nickname}"
      sleep 0.5
      # 記事2の投稿者のページへ遷移することを確認する
      expect(current_path).to eq user_path(@article2.user)
      sleep 0.5

      # チャットへGoボタンがないことを確認する
      expect(page).to have_no_content("チャットへGo")
      
      # チャットページへ移動する
      visit room_path(@room1)

      # ログインページへ遷移することを確認する
      expect(current_path).to eq new_user_session_path
    end

    it "第三者はチャットできない" do
      # トップページに移動する
      visit root_path

      # ユーザー3でログインする
      sign_in(@user3)

      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path

      # 記事2の投稿者のページへ遷移する
      click_on "#{@article2.user.nickname}"
      sleep 0.5
      # 記事2の投稿者のページへ遷移することを確認する
      expect(current_path).to eq user_path(@article2.user)
      sleep 0.5

      # チャットへGoボタンがないことを確認する
      expect(page).to have_no_content("チャットへGo")        
      
      # チャットページへ移動する
      visit room_path(@room1)

      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
    end
  end
end

RSpec.describe "チャット一覧機能", js: true, type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @user3 = FactoryBot.create(:user)
    @profile1 = FactoryBot.create(:profile, user_id: @user1.id)
    @profile2 = FactoryBot.create(:profile, user_id: @user2.id)
    @profile3 = FactoryBot.create(:profile, user_id: @user3.id)
    @article1 = FactoryBot.create(:article1, user_id: @user1.id)
    @article2 = FactoryBot.create(:article2, user_id: @user2.id)
    @tag1 = FactoryBot.create(:tag)
    ArticleTagRelation.create(article_id: @article1.id, tag_id: @tag1.id)
    ArticleTagRelation.create(article_id: @article2.id, tag_id: @tag1.id)
    @comment1 = FactoryBot.create(:comment1, user_id: @user1.id, article_id: @article2.id)
    @comment2 = FactoryBot.create(:comment2, user_id: @user3.id, article_id: @article2.id)
    Relationship.create(user_id: @user1.id, follower_id: @user2.id)
    Relationship.create(user_id: @user2.id, follower_id: @user1.id)
    @room1 = FactoryBot.create(:room1)
    @room2 = FactoryBot.create(:room2)
    Entry.create(user_id: @user1.id, room_id: @room1.id)
    Entry.create(user_id: @user2.id, room_id: @room1.id)
    @chat1 = FactoryBot.build(:chat1, user_id: @user1.id, room_id: @room1.id)
    @chat2 = FactoryBot.build(:chat2, user_id: @user2.id, room_id: @room2.id)
  end

  context "チャットできる時" do
    it "ログインしたらチャットできる" do
      # トップページに移動する
      visit root_path

      # ユーザー1でログインする
      sign_in(@user1)

      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path

      # チャット一覧ページへ遷移する
      visit rooms_path

      expect(page).to have_content("チャットルーム一覧")
      click_on "@#{@user2.nickname}"
      sleep 0.5
      # チャットページへ遷移することを確認する
      expect(current_path).to eq room_path(@room1)

      # チャット入力する
      fill_in "chat-sentence", with: "user1からuser2へチャット送信テストです"

      # 送信する
      find("#chat-send-button").click
      sleep 0.5
      # 送信したことを確認する
      expect(page).to have_content("user1からuser2へチャット送信テストです")
    end
  end

  context "チャットできない時" do
    it "ログインしていないとチャットできない" do
      # トップページに移動する
      visit root_path

      # チャット一覧ページへ遷移する
      visit rooms_path

      # ログインページへ遷移することを確認する
      expect(current_path).to eq new_user_session_path
    end

    it "第三者はチャットできない" do
      # トップページに移動する
      visit root_path

      # ユーザー3でログインする
      sign_in(@user3)

      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path

      # チャット一覧ページへ遷移する
      visit rooms_path

      # 参加できるチャットがないことを確認する
      expect(page).to have_content("チャットルーム一覧")
      expect(page).to have_content("チャットはありません")
    end
  end

end