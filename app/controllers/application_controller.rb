class ApplicationController < ActionController::API
  before_action :set_default_format

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :render_bad_request

  private

  def set_default_format
    request.format = :json
  end

  def authenticate_user!
    header = request.headers["Authorization"]
    token = header.to_s.split(" ").last
    if token.blank?
      return render json: { error: "Authorization token missing" }, status: :unauthorized
    end

    begin
      decoded = JWT.decode(token, jwt_secret, true, { algorithm: "HS256" })
      user_id = decoded.first["sub"]
      @current_user = User.find(user_id)
    rescue JWT::ExpiredSignature
      render json: { error: "Token has expired" }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def jwt_secret
    ENV.fetch("JWT_SECRET") { Rails.application.credentials.dig(:jwt, :secret_key) || Rails.application.secret_key_base }
  end

  def issue_token(user)
    exp = 24.hours.from_now.to_i
    payload = { sub: user.id, exp: exp }
    JWT.encode(payload, jwt_secret, "HS256")
  end

  def render_not_found(err)
    render json: { error: "Not Found", message: err.message }, status: :not_found
  end

  def render_unprocessable_entity(err)
    record = err.record
    render json: { error: "Validation Failed", details: record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_bad_request(err)
    render json: { error: "Bad Request", message: err.message }, status: :bad_request
  end
end
