class JwtService
  JWT_SECRET = Rails.application.credentials.jwt_secret_key

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, JWT_SECRET)
  end

  def self.decode(token)
    return nil if Blacklist.exists?(token: token)

    decoded = JWT.decode(token, JWT_SECRET)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
    nil
  rescue JWT::DecodeError
    nil
  end
end
