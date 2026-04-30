require 'bcrypt'

helpers do
  USER_ROLES = %w[admin editor reader].freeze

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

  def editor?
    logged_in? && current_user.role == 'editor'
  end

  def reader?
    logged_in? && current_user.role == 'reader'
  end

  def can_manage_links?
    admin? || editor?
  end

  def authenticate!
    redirect '/login' unless logged_in?
  end
end
