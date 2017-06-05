class UsersController < ApplicationController
  def show
    authenticate_user!

    @user = current_user
  end
end
