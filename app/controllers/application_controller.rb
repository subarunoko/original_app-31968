class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    #新規登録時nicknameの取得を許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :image])
    
    #情報更新時nicknameの取得を許可
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname])
  end
end
