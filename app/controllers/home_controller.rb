class HomeController < ApplicationController
  def index
    redirect_to "/questions"
  end
end
