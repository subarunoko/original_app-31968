require 'rails_helper'

RSpec.describe "記事投稿", type: :system do
# RSpec.describe "記事投稿", js: true, type: :system do
  before do
    @user = FactoryBot.create(:user)
    @profile = FactoryBot.create(:profile, user_id: @user.id)
    @article = FactoryBot.build(:article_tag, user_id: @user.id)
  end
  context "記事投稿できる時" do
    it "ログインしたユーザーは記事投稿できる" do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      # expect(page).to have_content("ログイン")

      # ログインページへ遷移する
      click_on "ログイン" 

      # 正しいユーザー情報を入力する
      fill_in "メールアドレス", with: @user.email
      fill_in "パスワード", with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      # expect(current_path).to eq root_path

      # 記事投稿ページへ遷移する
      click_on "投稿する"

      # 記事投稿ページへ遷移することを確認する
      expect(current_path).to eq new_article_path
      # 正しい記事情報を入力する     
      fill_in "title", with: @article.title
      fill_in "tag_ids", with: @article.tag_ids
      # find('#tag_ids', visible: false).set("Hello World")
      # fill_in ".CodeMirror-scroll", with: @article.body
      find('.CodeMirror', visible: false).set("Hello World")
      # find('.CodeMirror textarea').set("Hello World")
      # driver.execute_script('FTAPP.editor.codemirror.setValue("Hello World");')


      # 投稿するボタンを押す
      # ユーザーモデル/プロフィールモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change {Article.count & Tag.count}.by(1)

      # 投稿完了ページへ移動する
      # 投稿完了ページへ遷移することを確認する
      expect(current_path).to eq create_done_articles_path
      expect(page).to have_content("投稿が完了しました")

      # トップページへ移動する
      click_on "トップページへ戻る"

      # トップページへ遷移することを確認
      expect(current_path).to eq root_path

      # 投稿した記事が存在することを確認する
      expect(page).to have_content("#{@article.title}")
    end
  end

  context "記事投稿できない時" do
    it "ログインしていないと記事投稿できない" do
      # トップページに移動する
      visit root_path
      # 投稿するするボタンが表示されていないことを確認する
      expect(page).to have_no_content("投稿する")
      # 投稿ページへ移動する
      visit new_article_path      
      # 投稿完了ページへ遷移することを確認する
      expect(current_path).to eq new_user_session_path
    end

    it "タイトルが空欄だと記事投稿できない" do
      # トップページに移動する
      visit root_path

      # ログインページへ遷移する
      click_on "ログイン" 

      # 正しいユーザー情報を入力する
      fill_in "メールアドレス", with: @user.email
      fill_in "パスワード", with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      # expect(current_path).to eq root_path

      # 記事投稿ページへ遷移する
      click_on "投稿する"

      # 記事投稿ページへ遷移することを確認する
      expect(current_path).to eq new_article_path
      # 記事情報を入力する     
      fill_in "title", with: ""
      fill_in "tag_ids", with: @article.tag_ids

      # 投稿するボタンを押す
      # ユーザーモデル/プロフィールモデルのカウントが1上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change {Article.count & Tag.count}.by(0)

      # 投稿完了ページへ遷移しないことを確認する
      expect(page).to have_content("タイトルを入力してください")
    end

    it "タグが空欄/5個以上/カンマ/全角入力だと記事投稿できない" do
      # トップページに移動する
      visit root_path

      # ログインページへ遷移する
      click_on "ログイン" 

      # 正しいユーザー情報を入力する
      fill_in "メールアドレス", with: @user.email
      fill_in "パスワード", with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      # expect(current_path).to eq root_path

      # 記事投稿ページへ遷移する
      click_on "投稿する"

      # 記事投稿ページへ遷移することを確認する
      expect(current_path).to eq new_article_path
      # 記事情報を入力する     
      fill_in "title", with: @article.title
      fill_in "tag_ids", with: ""

      # 投稿するボタンを押す
      # ユーザーモデル/プロフィールモデルのカウントが1上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change {Article.count & Tag.count}.by(0)

      # 投稿完了ページへ遷移しないことを確認する
      expect(page).to have_content("タグを入力してください")

      # 記事情報を入力する     
      # fill_in "title", with: @article.title
      fill_in "tag_ids", with: "tag1 tag2 tag3 tag4 tag5 tag6"

      # 投稿するボタンを押す
      # ユーザーモデル/プロフィールモデルのカウントが1上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change {Article.count & Tag.count}.by(0)

      # 投稿完了ページへ遷移しないことを確認する
      expect(page).to have_content("タグのタグ数の上限を超えてます 修正して下さい")

      # 記事情報を入力する     
      # fill_in "title", with: @article.title
      fill_in "tag_ids", with: "tag1,tag2,tag3,tag4,tag5"

      # 投稿するボタンを押す
      # ユーザーモデル/プロフィールモデルのカウントが1上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change {Article.count & Tag.count}.by(0)

      # 投稿完了ページへ遷移しないことを確認する
      expect(page).to have_content("カンマは使用できません 半角スペースへ修正して下さい")

      # 記事情報を入力する     
      # fill_in "title", with: @article.title
      fill_in "tag_ids", with: "tag1　tag2　tag3　tag4　tag5"

      # 投稿するボタンを押す
      # ユーザーモデル/プロフィールモデルのカウントが1上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change {Article.count & Tag.count}.by(0)

      # 投稿完了ページへ遷移しないことを確認する
      expect(page).to have_content("全角スペースは使用できません 半角スペースへ修正して下さい")
    end
  end  
end



RSpec.describe "記事編集", type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @profile1 = FactoryBot.create(:profile, user_id: @user1.id)
    @profile2 = FactoryBot.create(:profile, user_id: @user2.id)
    @article1 = FactoryBot.create(:article1, user_id: @user1.id)
    @article2 = FactoryBot.create(:article2, user_id: @user2.id)
    @tag1 = FactoryBot.create(:tag)
    # @tag2 = FactoryBot.create(:tag)
    ArticleTagRelation.create(article_id: @article1.id, tag_id: @tag1.id)
    ArticleTagRelation.create(article_id: @article2.id, tag_id: @tag1.id)
  end

  context "記事編集できる時" do
    it "ログインしたユーザーは記事投稿できる" do
      # トップページに移動する
      visit root_path

      # ログインページへ遷移する
      click_on "ログイン" 

      # 正しいユーザー情報を入力する
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
      
      # 記事1の編集ページへ遷移する
      # click_on "編集する"
      find(".show-article-edit-btn").click

      # 記事編集ページへ遷移することを確認する
      expect(current_path).to eq edit_article_path(@article1)
      # 正しい記事情報を入力する
      fill_in "article_tag_title", with: "test1"
      fill_in "article_tag_tag_ids", with: "tag1"
      # binding.pry

      # 編集するボタンを押す
      # ユーザーモデル/プロフィールモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      # }.to change {Article.count & Tag.count}.by(0)
      }.to change {Article.count}.by(0)

      # 編集完了ページへ移動する
      # 編集完了ページへ遷移することを確認する
      expect(current_path).to eq update_done_article_path(@article1)
      expect(page).to have_content("編集が完了しました")

      # トップページへ移動する
      click_on "トップページへ戻る"

      # トップページへ遷移することを確認
      expect(current_path).to eq root_path

      # 投稿した記事が存在することを確認する
      expect(page).to have_content("test1")
    end
  end

  context "記事投稿できない時" do
    it "ログインしていないと記事編集できない" do
      # トップページに移動する
      visit root_path

      # 記事1ページへ遷移する
      click_on "#{@article1.title}"

      # 記事投稿ページへ遷移することを確認する
      expect(current_path).to eq article_path(@article1)

      # 投稿するするボタンが表示されていないことを確認する
      expect(page).to have_no_content("編集する")

      # トップページに移動する
      visit root_path

      # 記事編集ページへ遷移することを確認する
      visit edit_article_path(@article1)    
      # ログインページへ遷移することを確認する
      expect(current_path).to eq new_user_session_path
    end

    it "投稿者とログインユーザーが違うと記事編集できない" do
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
      click_on "#{@article1.title}"
      
      # 記事投稿ページへ遷移することを確認する
      expect(current_path).to eq article_path(@article1)

      # 投稿するするボタンが表示されていないことを確認する
      expect(page).to have_no_content("編集する")

      # トップページに移動する
      visit root_path

      # 記事編集ページへ遷移することを確認する
      visit edit_article_path(@article1)    
      # 投稿完了ページへ遷移することを確認する
      expect(current_path).to eq root_path
    end

    it "タイトル等が空欄だと記事編集できない" do
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
      
      # 記事1の編集ページへ遷移する
      # click_on "編集する"
      find(".show-article-edit-btn").click

      # 記事編集ページへ遷移することを確認する
      expect(current_path).to eq edit_article_path(@article1)
      # 記事情報を入力する
      fill_in "article_tag_title", with: ""
      fill_in "article_tag_tag_ids", with: "tag1"
      # binding.pry

      # 編集するボタンを押す
      # ユーザーモデル/プロフィールモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      # }.to change {Article.count & Tag.count}.by(0)
      }.to change {Article.count}.by(0)

      # 編集完了ページへ遷移しないことを確認する
      expect(page).to have_content("タイトルを入力してください")

      # 記事情報を入力する
      fill_in "article_tag_title", with: "test1"
      fill_in "article_tag_tag_ids", with: ""

      # 編集するボタンを押す
      # ユーザーモデル/プロフィールモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      # }.to change {Article.count & Tag.count}.by(0)
      }.to change {Article.count}.by(0)

      # 編集完了ページへ遷移しないことを確認する
      expect(page).to have_content("タグを入力してください")
    end
  end
end

RSpec.describe "記事削除", type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @profile1 = FactoryBot.create(:profile, user_id: @user1.id)
    @profile2 = FactoryBot.create(:profile, user_id: @user2.id)
    @article1 = FactoryBot.create(:article1, user_id: @user1.id)
    @article2 = FactoryBot.create(:article2, user_id: @user2.id)
    @tag1 = FactoryBot.create(:tag)
    # @tag2 = FactoryBot.create(:tag)
    ArticleTagRelation.create(article_id: @article1.id, tag_id: @tag1.id)
    ArticleTagRelation.create(article_id: @article2.id, tag_id: @tag1.id)
  end

  context "記事削除できる時" do
    it "ログインしたユーザーは記事削除できる" do
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

      # 記事1の編集ページへ遷移する
      # click_on "編集する"
      find(".show-article-del-btn").click

      # 記事編集ページへ遷移することを確認する
      expect(current_path).to eq destroy_caution_article_path(@article1)

      # 削除するボタンを押す
      # ユーザーモデル/プロフィールモデルのカウントが1下がることを確認する
      expect{
        click_on "削除する"
      # }.to change {Article.count & Tag.count}.by(0)
      }.to change {Article.count}.by(-1)

      # 削除完了ページへ移動する
      # 削除完了ページへ遷移することを確認する
      expect(current_path).to eq destroy_done_article_path(@article1)
      expect(page).to have_content("削除が完了しました")

      # トップページへ移動する
      click_on "トップページへ戻る"

      # トップページへ遷移することを確認
      expect(current_path).to eq root_path

      # 削除した記事が存在しないことを確認する(記事1)
      expect(page).to have_no_content("#{@article1.title}")

      # 記事が存在することを確認する(記事2)
      expect(page).to have_content("#{@article2.title}")
    end
  end

  context "記事投稿できない時" do
    it "ログインしていないと記事削除できない" do
      # トップページに移動する
      visit root_path

      # 記事1ページへ遷移する
      click_on "#{@article1.title}"

      # 記事投稿ページへ遷移することを確認する
      expect(current_path).to eq article_path(@article1)

      # 投稿するするボタンが表示されていないことを確認する
      expect(page).to have_no_content("削除する")

      # トップページに移動する
      visit root_path

      # 記事削除ページへ遷移することを確認する
      visit destroy_caution_article_path(@article1)    
      # ログインページへ遷移することを確認する
      expect(current_path).to eq new_user_session_path
    end

    it "投稿者とログインユーザーが違うと記事削除できない" do
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
      click_on "#{@article1.title}"
      
      # 記事投稿ページへ遷移することを確認する
      expect(current_path).to eq article_path(@article1)

      # 投稿するするボタンが表示されていないことを確認する
      expect(page).to have_no_content("削除する")

      # トップページに移動する
      visit root_path

      # 記事削除ページへ遷移する
      visit destroy_caution_article_path(@article1)    
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
    end
  end
end