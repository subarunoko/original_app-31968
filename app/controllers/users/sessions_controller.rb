class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    if user.profile.nil? 
      profile = Profile.guest(user)
    end
    sign_in user
    redirect_to root_path, notice: "ゲストユーザーとしてログインしました"
  end
end
