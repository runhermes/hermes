class ApplicationController < ActionController::API
  before_action :set_basecamp_redirect_uri

  private

  def set_basecamp_redirect_uri
    if Rails.configuration.basecamp.redirect_uri.blank?
      Rails.configuration.basecamp.redirect_uri = "#{request.base_url}/basecamp/callback"
    end
  end
end
