require 'rails_helper'

RSpec.describe "ユーザー新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
    @profile = FactoryBot.build(:profile)
  end
    
  context "ユーザー新規登録ができる時" do
    it "正しい情報を入力すればユーザー新規登録ができてトップページに移動する"  do
      # トップページに移動する
      visit root_path
      # トップページにユーザー登録ボタンがあることを確認する
      expect(page).to have_content("ユーザー登録")
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in "ニックネーム", with: @user.nickname
      fill_in "メールアドレス", with: @user.email
      fill_in "パスワード", with: @user.password
      fill_in "パスワード（確認用）", with: @user.password_confirmation
      # プロフィールページへ移動する
      click_on "次へ"

      # プルダウンから情報を選択する
      select "Ruby", from: "profile[language_id]"
      # プロフィール情報を入力する
      # fill_in "プロフィール", with: @profile.description
      fill_in "プロフィール", with: "Hello World"
      # プロフィールページへ移動する
      click_on "次へ"

      # ページに次へボタンがあることを確認する
      expect(page).to have_content("登録する")
      expect(page).to have_content("戻る")
      
      # 登録完了ページへ移動する
      # ユーザーモデル/プロフィールモデルのカウントが1上がることを確認する
      # expect{
      #   click_on "登録する"
      # }.to change {User.count}.by(1), change {Profile.count}.by(1)
      expect{
        click_on "登録する"
      }.to change {User.count & Profile.count}.by(1)

      # 登録完了ページへ移動することを確認
      expect(current_path).to eq profiles_path
      # 登録が完了しましたの表示があることを確認する
      expect(page).to have_content("※登録が完了しました")
      # トップページへ移動する
      click_on "トップページへ移動する"

      # トップページへ遷移することを確認
      expect(current_path).to eq root_path
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content("ユーザー登録")
      expect(page).to have_no_content("ログイン")  
    end
  end
  context "ユーザー新規登録ができない時" do
    it 'ユーザー情報が空欄ではユーザー登録ができない' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content("ユーザー登録")
      # 新規登録ページへ移動する
      click_on "ユーザー登録" 
      # visit new_user_registration_path

      # ユーザー情報を入力する
      fill_in "ニックネーム", with: ""
      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: ""
      fill_in "パスワード（確認用）", with: ""
      
      # プロフィールページへ移動する
      # ユーザーモデル/プロフィールモデルのカウントが上がらないことを確認する
      expect{
        click_on "次へ"
      }.to change {User.count & Profile.count}.by(0)
      # ユーザー登録ページである確認(ページ遷移しない)
      expect(page).to have_content("ニックネームを入力してください")
      expect(page).to have_content("パスワードを入力してください")
      expect(page).to have_content("メールアドレスを入力してください")
    end

    it 'PASSが6文字以下ではユーザー登録ができない' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content("ユーザー登録")
      # 新規登録ページへ移動する
      click_on "ユーザー登録" 
      # visit new_user_registration_path

      # ユーザー情報を入力する
      fill_in "ニックネーム", with: @user.nickname
      fill_in "メールアドレス", with: @user.email
      fill_in "パスワード", with: "12345"
      fill_in "パスワード（確認用）", with: "12345"

      # プロフィールページへ移動する
      # ユーザーモデル/プロフィールモデルのカウントが上がらないことを確認する
      expect{
        click_on "次へ"
      }.to change {User.count & Profile.count}.by(0)
      # ユーザー登録ページである確認(ページ遷移しない)
      expect(page).to have_content("パスワードは6文字以上で入力してください")
    end

    it 'PASSが一致していないとユーザー登録ができない' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content("ユーザー登録")
      # 新規登録ページへ移動する
      click_on "ユーザー登録" 
      # visit new_user_registration_path

      # ユーザー情報を入力する
      fill_in "ニックネーム", with: @user.nickname
      fill_in "メールアドレス", with: @user.email
      fill_in "パスワード", with: "123456"
      fill_in "パスワード（確認用）", with: ""

      # プロフィールページへ移動する
      # ユーザーモデル/プロフィールモデルのカウントが上がらないことを確認する
      expect{
        click_on "次へ"
      }.to change {User.count & Profile.count}.by(0)
      # ユーザー登録ページである確認(ページ遷移しない)
      expect(page).to have_content("パスワード（確認用）とパスワードの入力が一致しません")
    end

    it '学習言語が選択できていないとユーザー登録ができない' do
      # トップページに移動する
      visit root_path
      # トップページにユーザー登録ボタンがあることを確認する
      expect(page).to have_content("ユーザー登録")
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in "ニックネーム", with: @user.nickname
      fill_in "メールアドレス", with: @user.email
      fill_in "パスワード", with: @user.password
      fill_in "パスワード（確認用）", with: @user.password_confirmation
      # プロフィールページへ移動する
      click_on "次へ"

      # プルダウンから情報を選択する
      select "---", from: "profile[language_id]"
      # プロフィール情報を入力する
      fill_in "プロフィール", with: ""
      
      # プロフィールページへ移動する
      # ユーザーモデル/プロフィールモデルのカウントが上がらないことを確認する
      expect{
        click_on "次へ"
      }.to change {User.count & Profile.count}.by(0)
      # ユーザー登録ページである確認(ページ遷移しない)
      expect(page).to have_content("Languageが未選択です")
    end

    it 'プロフィールが250文字以内でないとユーザー登録ができない' do
      # トップページに移動する
      visit root_path
      # トップページにユーザー登録ボタンがあることを確認する
      expect(page).to have_content("ユーザー登録")
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in "ニックネーム", with: @user.nickname
      fill_in "メールアドレス", with: @user.email
      fill_in "パスワード", with: @user.password
      fill_in "パスワード（確認用）", with: @user.password_confirmation
      # プロフィールページへ移動する
      click_on "次へ"

      # プルダウンから情報を選択する
      select "Ruby", from: "profile[language_id]"
      # プロフィール情報を入力する
      rnd_description = Faker::Lorem.characters(number: 251, min_alpha: 100, min_numeric: 100)
      fill_in "プロフィール", with: rnd_description
      
      # プロフィールページへ移動する
      # ユーザーモデル/プロフィールモデルのカウントが上がらないことを確認する
      expect{
        click_on "次へ"
      }.to change {User.count & Profile.count}.by(0)
      # ユーザー登録ページである確認(ページ遷移しない)
      expect(page).to have_content("プロフィールが文字数の上限を超えてます")
    end
  end
end


# 以下、ログイン／ログアウトのテストコード
RSpec.describe "ログイン", type: :system do
  before do
    @user = FactoryBot.create(:user)
    # @profile = FactoryBot.create(:profile)
    @profile = FactoryBot.create(:profile, user_id: @user.id)
  end
  context "ログインできる時" do
    it "保存されているユーザーの情報と合致すればログインできる" do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content("ログイン")
      # ログインページへ遷移する
      click_on "ログイン" 

      # 正しいユーザー情報を入力する
      fill_in "メールアドレス", with: @user.email
      fill_in "パスワード", with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # binding.pry
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content("ユーザー登録")
      expect(page).to have_no_content("ログイン")
    end
  end

  context "ログインできない時" do
    it "入力フォームが空欄だとログインできない" do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content("ログイン")
      # ログインページへ遷移する
      click_on "ログイン" 

      # ユーザー情報を入力する
      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: ""
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ユーザー登録ページである確認(ページ遷移しない)
      expect(page).to have_content("メールアドレスまたはパスワードが違います。")
    end
  end  
end
