class HomeController < ApplicationController
  def index
    render plain: "Welcome to Hermes"
  end

  def healthz
    head :no_content
  end
end
