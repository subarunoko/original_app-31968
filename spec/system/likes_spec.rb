require 'rails_helper'

RSpec.describe "いいね機能", js: true, type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @user3 = FactoryBot.create(:user)
    @profile1 = FactoryBot.create(:profile, user_id: @user1.id)
    @profile2 = FactoryBot.create(:profile, user_id: @user2.id)
    @article1 = FactoryBot.create(:article1, user_id: @user1.id)
    @article2 = FactoryBot.create(:article2, user_id: @user2.id)
    @tag1 = FactoryBot.create(:tag)
    ArticleTagRelation.create(article_id: @article1.id, tag_id: @tag1.id)
    ArticleTagRelation.create(article_id: @article2.id, tag_id: @tag1.id)
    @comment1 = FactoryBot.create(:comment1, user_id: @user1.id, article_id: @article2.id)
    @comment2 = FactoryBot.create(:comment2, user_id: @user3.id, article_id: @article2.id)
  end

  context "いいねできる時" do
    it "ログインしたユーザーはいいねできる" do
      # トップページに移動する
      visit root_path

      # ユーザー1でログインする
      sign_in(@user1)

      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      
      # いいねボタンを押す
      # いいねのカウント数が1上がることを確認する
      find("#like-btn-#{@article2.id}").click
      sleep 0.5
      expect(@article2.likes.count).to eq(1)

      # いいねボタンを押す
      # いいねのカウント数が1下がることを確認する
      find("#like-btn-#{@article2.id}").click
      sleep 0.5
      expect(@article2.likes.count).to eq(0)
    end
  end

  context "いいねできない時" do
    it "ログインしていないユーザーはいいねできない" do
      # トップページに移動する
      visit root_path
      
      # いいねボタンを押す
      # いいねのカウント数が変化しないことを確認する
      find("#like-btn-#{@article2.id}").click
      sleep 0.5
      expect(@article2.likes.count).to eq(0)
    end
  end
end

RSpec.describe "いいねしたユーザ一覧機能", js: true, type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @user3 = FactoryBot.create(:user)
    @profile1 = FactoryBot.create(:profile, user_id: @user1.id)
    @profile2 = FactoryBot.create(:profile, user_id: @user2.id)
    @article1 = FactoryBot.create(:article1, user_id: @user1.id)
    @article2 = FactoryBot.create(:article2, user_id: @user2.id)
    @tag1 = FactoryBot.create(:tag)
    ArticleTagRelation.create(article_id: @article1.id, tag_id: @tag1.id)
    ArticleTagRelation.create(article_id: @article2.id, tag_id: @tag1.id)
    @comment1 = FactoryBot.create(:comment1, user_id: @user1.id, article_id: @article2.id)
    @comment2 = FactoryBot.create(:comment2, user_id: @user3.id, article_id: @article2.id)
  end

  context "いいねしたユーザーが存在する時" do
    it "いいね一覧に表示される" do
      # トップページに移動する
      visit root_path

      # ユーザー1でログインする
      sign_in(@user1)

      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      
      # いいねボタンを押す
      # いいねのカウント数が1上がることを確認する
      find("#like-btn-#{@article2.id}").click
      sleep 0.5
      expect(@article2.likes.count).to eq(1)

      # いいねしたユーザーボタンを押す
      find("#icon-count-#{@article2.id}").click

      # いいね一覧ページへ遷移したことを確認する
      expect(current_path).to eq like_user_path(@article2)
      expect(page).to have_content("いいねしたユーザー")
 
      # いいねしたユーザーがあることを確認する     
      expect(page).to have_content("#{@user1.nickname}")
    end
  end

  context "いいねしたユーザーが存在しない時" do
    it "いいね一覧に表示されない" do
      # トップページに移動する
      visit root_path

      # ユーザー1でログインする
      sign_in(@user1)

      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      
      # いいねしたユーザーボタンを押す
      find("#icon-count-#{@article2.id}").click

      # いいね一覧ページへ遷移したことを確認する
      expect(current_path).to eq like_user_path(@article2)
      expect(page).to have_content("いいねしたユーザー")
 
      # いいねしたユーザーがあることを確認する     
      expect(page).to have_content("いいねしたユーザーはいません")
    end
  end
end