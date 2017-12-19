class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_current_user

  protected

  def set_current_user
    UserInfo.current_user = current_user
  end
end
