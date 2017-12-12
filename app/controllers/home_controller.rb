class HomeController < ApplicationController
  before_action :authenticate_user!
  
  def show
    render
  end
end
