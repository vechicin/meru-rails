class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    auth_header = request.headers['Authorization']
    if auth_header.present?
      token = auth_header.split(' ').last
      payload = JwtService.decode(token)
      if payload
        current_time = Time.now.to_i
        if payload[:exp] > current_time
          @current_user = User.find_by(id: payload[:user_id])
          if @current_user.nil?
            render json: { error: 'Invalid token' }, status: :unauthorized
          end
        else
          render json: { error: 'Token has expired' }, status: :unauthorized
        end
      else
        render json: { error: 'Invalid or expired token'}, status: :unauthorized
      end
    else
      render json: { error: 'Missing token'}, status: :unauthorized
    end
  end
end
