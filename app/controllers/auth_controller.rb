class AuthController < ApplicationController
  def register
    user = User.new(user_params)
    if user.save
      token = issue_token(user)
      render json: { token: token, user: UserSerializer.new(user) }, status: :created
    else
      render json: { error: "Validation Failed", details: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    email = params.dig(:user, :email) || params[:email]
    password = params.dig(:user, :password) || params[:password]

    user = User.find_by(email: email.to_s.downcase)
    if user&.authenticate(password)
      token = issue_token(user)
      render json: { token: token, user: UserSerializer.new(user) }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
