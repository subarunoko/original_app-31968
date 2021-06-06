class RoomsController < ApplicationController
  before_action :set_profile, only: [:index, :show]

  def index
  end

  def show
  end


  private

  def set_profile
    @user_prof = current_user
  end

end
