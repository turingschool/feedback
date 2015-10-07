class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    binding.pry
    if cookies[:feedback_user]
      @current_user = User.find(cookies.signed[:feedback_user])
    else
      @current_user ||= User.new
    end
  end
end
