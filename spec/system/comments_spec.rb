require 'rails_helper'

RSpec.describe "コメント投稿", js: true, type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @profile1 = FactoryBot.create(:profile, user_id: @user1.id)
    @profile2 = FactoryBot.create(:profile, user_id: @user2.id)
    @article1 = FactoryBot.create(:article1, user_id: @user1.id)
    @article2 = FactoryBot.create(:article2, user_id: @user2.id)
    @tag1 = FactoryBot.create(:tag)
    ArticleTagRelation.create(article_id: @article1.id, tag_id: @tag1.id)
    @comment = FactoryBot.build(:comment1, user_id: @user1.id, article_id: @article1.id)
  end

  context "コメント投稿できる時" do
    it "ログインしたユーザーはコメント投稿できる" do
      # トップページに移動する
      visit root_path

      # ログインページへ遷移する
      click_on "ログイン" 

      # ユーザー1でログインする
      fill_in "メールアドレス", with: @user1.email
      fill_in "パスワード", with: @user1.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path

      # 記事1ページへ遷移する
      click_on "#{@article2.title}"
      
      # 記事投稿ページへ遷移することを確認する
      expect(current_path).to eq article_path(@article2)
      # コメント投稿があることを確認する
      expect(page).to have_content("相手のことを考え丁寧なコメントを心がけましょう")

      # コメント投稿する
      fill_in "comment", with: "コメント投稿のテストです"
      # コメントボタンを押す
      find('input[name="commit"]').click

      sleep 1

      # 投稿完了ページへ遷移しないことを確認する
      expect(page).to have_content("#{@user1.nickname}")
      expect(page).to have_content("コメント投稿のテストです")
    end
  end

  context "コメント投稿できない時" do
    it "ログインしていないとコメント投稿できない" do
      # トップページに移動する
      visit root_path

      # 記事1ページへ遷移する
      click_on "#{@article1.title}"
      
      # 記事投稿ページへ遷移することを確認する
      expect(current_path).to eq article_path(@article1)
      # コメント投稿がないことを確認する
      expect(page).to have_no_content("相手のことを考え丁寧なコメントを心がけましょう")
      expect(page).to have_content("コメントの投稿には新規登録/ログインが必要です")
    end

    it "記事の投稿者とログインユーザーが同じだとコメント投稿できない" do
      # トップページに移動する
      visit root_path

      # ログインページへ遷移する
      click_on "ログイン" 

      # ユーザー1でログインする
      fill_in "メールアドレス", with: @user1.email
      fill_in "パスワード", with: @user1.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path

      # 記事1ページへ遷移する
      click_on "#{@article1.title}"
      
      # 記事投稿ページへ遷移することを確認する
      expect(current_path).to eq article_path(@article1)
      # コメント投稿がないことを確認する
      expect(page).to have_no_content("相手のことを考え丁寧なコメントを心がけましょう")
    end
  end
end

RSpec.describe "コメント削除", js: true, type: :system do
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
    @comment1 = FactoryBot.create(:comment1, user_id: @user1.id, article_id: @article2.id)
    @comment2 = FactoryBot.create(:comment2, user_id: @user3.id, article_id: @article2.id)
  end

  context "コメント削除できる時" do
    it "ログインしたユーザーはコメント削除できる" do
      # トップページに移動する
      visit root_path

      # ログインページへ遷移する
      click_on "ログイン" 

      # ユーザー1でログインする
      fill_in "メールアドレス", with: @user1.email
      fill_in "パスワード", with: @user1.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path

      # 記事2ページへ遷移する
      click_on "#{@article2.title}"
      
      # 記事2ページへ遷移することを確認する
      expect(current_path).to eq article_path(@article2)
      # コメント投稿があることを確認する
      expect(page).to have_content("相手のことを考え丁寧なコメントを心がけましょう")

      # コメント1を削除する
      find(".show-comment-del-btn-text").click

      sleep 1

      # コメント1がないことを確認する
      expect(page).to have_no_content("#{@comment1.text}")
    end
  end

  context "コメント削除できない時" do
    it "ログインしていないとコメント削除できない" do
      # トップページに移動する
      visit root_path

      # 記事1ページへ遷移する
      click_on "#{@article2.title}"
      
      # 記事投稿ページへ遷移することを確認する
      expect(current_path).to eq article_path(@article2)
      # コメント投稿がないことを確認する
      expect(page).to have_no_content("相手のことを考え丁寧なコメントを心がけましょう")
      expect(page).to have_content("コメントの投稿には新規登録/ログインが必要です")
    end

    it "コメント投稿者とログインユーザーが違うとコメント削除できない" do
      # トップページに移動する
      visit root_path

      # ログインページへ遷移する
      click_on "ログイン" 

      # ユーザー2でログインする
      fill_in "メールアドレス", with: @user2.email
      fill_in "パスワード", with: @user2.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path

      # 記事1ページへ遷移する
      click_on "#{@article2.title}"
      
      # 記事投稿ページへ遷移することを確認する
      expect(current_path).to eq article_path(@article2)
      # コメント削除がないことを確認する
      expect(page).to have_no_content("コメント削除")
    end
  end
end