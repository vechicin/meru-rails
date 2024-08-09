class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :index]

  def index
    @users = User.all
    render json: @users
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: @user.errors.full_message }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
