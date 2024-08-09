class SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :refresh, :logout]
  def create
    user = User.find_by(username: params[:user][:username])

    if user&.authenticate(params[:user][:password])
      token = JwtService.encode(user_id: user.id)
      refresh_token = JwtService.encode(user_id: user.id, exp: 1.month.from_now)
      render json: { token: token, refresh_token: refresh_token }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def refresh
    payload = JwtService.decode(params[:refresh_token])
    if payload
      user = User.find_by(id: payload[:user_id])
      if user
        token = JwtService.encode(user_id: user.id)
        render json: { token: token }, status: :ok
      else
        render json: { error: 'Invalid user' }, status: :unauthorized
      end
    else
      render json: { error: 'Invalid refresh token' }, status: :unauthorized
    end
  end

  def logout
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      Blacklist.create(token: token)
      head :no_content
    else
      render json: { error: 'No token provided' }, status: :unprocessable_entity
    end
  end
end
