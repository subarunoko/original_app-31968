require 'rails_helper'

RSpec.describe "フォロー機能", js: true, type: :system do
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

  context "フォローできる時" do
    it "ログインしたらフォローできる" do
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

      # フォローボタンがあることを確認する
      # expect(page).to have_selector("input[value='フォローする']")

      # フォローボタンを押す
      # click_on "フォローする"
      find('input[name="commit"]').click
      sleep 0.5

      # フォロー解除ボタンがあることを確認する
      expect(page).to have_selector("input[value='フォロー解除']")
      
      # フォローのカウント数が1上がることを確認する
      expect(Relationship.count).to eq(1)

      # フォローボタンがないことを確認する
      expect(page).to have_no_selector("input[value='フォローする']")

      # フォロワーが1増えることを確認
      expect(@user2.followers.count).to eq(1)

      # マイアカウントのページへ遷移する
      visit user_path(@user1)

      # フォローが1増えることを確認
      expect(@user1.followings.count).to eq(1)

      # 記事2の投稿者のページへ遷移する
      visit user_path(@user2)

      # フォロー解除ボタンを押す
      # click_on "フォロー解除"
      find('input[name="commit"]').click
      sleep 0.5

      # フォローボタンがあることを確認する
      # expect(page).to have_selector("input[value='フォローする']")

      # フォロワーが1減ることを確認
      expect(@user2.followers.count).to eq(0)

      # フォロー解除ボタンがないことを確認する
      expect(page).to have_no_selector("input[value='フォロー解除']")

      # マイアカウントのページへ遷移する
      visit user_path(@user1)

      # フォローが1減ることを確認
      expect(@user1.followings.count).to eq(0)
    end
  end

  context "フォローできない時" do
    it "ログインしていないとフォローできない" do
      # トップページに移動する
      visit root_path

      # 記事2の投稿者のページへ遷移する
      click_on "#{@article2.user.nickname}"
      sleep 0.5
      # 記事2の投稿者のページへ遷移することを確認する
      expect(current_path).to eq user_path(@article2.user)
      sleep 0.5

      # フォローボタンがないことを確認する
      expect(page).to have_no_content('フォローする')
    end

    it "マイアカウントへはフォローできない" do
      # トップページに移動する
      visit root_path

      # ユーザー1でログインする
      sign_in(@user1)

      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path

      # マイアカウントのページへ遷移する
      visit user_path(@user1)
      sleep 0.5
      # フォローボタンがないことを確認する
      expect(page).to have_no_content('フォローする')
    end
  end
end

RSpec.describe "フォロ一覧機能", js: true, type: :system do
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

  context "フォロ一覧に表示される" do
    it "フォローしているユーザーが存在する時、一覧に表示される" do
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

      # フォローボタンを押す
      # click_on "フォローする"
      find('input[name="commit"]').click
      sleep 0.5

      # マイアカウントのページへ遷移する
      visit user_path(@user1)
      # # フォロークリック
      # find("#{@user1.followings.count}").click      
      visit following_user_path(@user1)

      # フォロー一覧ページへ遷移することを確認する
      # expect(current_path).to eq following_user_path(@user1)
      expect(page).to have_content("フォローしているユーザー")
      expect(find(".block-d")).to have_content("#{@user2.nickname}")
      expect(find(".block-d")).to have_selector("input[value='フォロー解除']")
    end

    it "フォロワーが存在する時、一覧に表示される" do
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

      # フォローボタンを押す
      # click_on "フォローする"
      find('input[name="commit"]').click
      sleep 0.5

      # マイアカウントのページへ遷移する
      visit user_path(@user2)
      # # フォロークリック
      # find("#{@user1.followings.count}").click      
      visit follower_user_path(@user2)

      # フォロー一覧ページへ遷移することを確認する
      # expect(current_path).to eq following_user_path(@user1)
      expect(page).to have_content("フォローされているユーザー")
      expect(find(".block-d")).to have_content("#{@user1.nickname}")
      # expect(find(".block-d")).to have_selector("input[value='フォロー解除']")
    end

  end

  context "フォロ一覧に表示されない" do
    it "フォローしているユーザーが存在しない時、一覧に表示されない" do
      # トップページに移動する
      visit root_path

      # ユーザー1でログインする
      sign_in(@user1)

      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path

      # 記事2の投稿者のページへ遷移する
      visit user_path(@user2)
      # # フォロークリック
      # find("#{@user1.followings.count}").click      
      visit following_user_path(@user2)

      # フォロー一覧ページへ遷移することを確認する
      # expect(current_path).to eq following_user_path(@user1)
      expect(page).to have_content("フォローしているユーザー")
      expect(page).to have_content("フォローしているユーザーはいません")
      # expect(find(".block-d")).to have_content("#{@user1.nickname}")
      # expect(find(".block-d")).to have_selector("input[value='フォロー解除']")
    end

    it "フォロワーが存在しない時、一覧に表示されない" do
      # トップページに移動する
      visit root_path

      # ユーザー1でログインする
      sign_in(@user1)

      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path

      # マイアカウントのページへ遷移する
      visit user_path(@user1)
      # # フォロークリック
      # find("#{@user1.followings.count}").click      
      visit follower_user_path(@user1)

      # フォロー一覧ページへ遷移することを確認する
      # expect(current_path).to eq following_user_path(@user1)
      expect(page).to have_content("フォローされているユーザー")
      expect(page).to have_content("フォロワーはいません")
      # expect(find(".block-d")).to have_content("#{@user1.nickname}")
      # expect(find(".block-d")).to have_selector("input[value='フォロー解除']")
    end
  end  
end