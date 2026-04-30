require 'bcrypt'

helpers do
  def current_user
    return nil unless session[:user_id]
    @current_user ||= User[session[:user_id]]
  end

  def logged_in?
    !current_user.nil?
  end

  def admin?
    logged_in? && current_user.role == 'admin'
  end

  def authenticate!
    redirect '/login' unless logged_in?
  end
end
