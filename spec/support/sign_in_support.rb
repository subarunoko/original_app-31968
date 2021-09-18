module SignInSupport
  def sign_in(user)
    # ログインページへ遷移する
    click_on "ログイン" 

    # 正しいユーザー情報を入力する
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    # ログインボタンを押す
    find('input[name="commit"]').click
  end
end