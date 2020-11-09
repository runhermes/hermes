class BasecampController < ApplicationController
  before_action :new_instance

  def oauth
    authz_uri = @basecamp.authorization_uri
    logger.info "Redirecting to #{authz_uri}"

    redirect_to authz_uri
  end

  def callback
    # Authorization Response
    return head(:bad_request) unless params.key? :code

    auth_code = params[:code]
    token = @basecamp.authorize! auth_code
    logger.info "Refresh Token: #{token.refresh_token}"
    logger.info "Access Token: #{token.access_token}"

    Rails.configuration.basecamp.refresh_token = token.refresh_token
    Rails.configuration.basecamp.access_token = token.access_token

    render plain: "Authentication successful"
  end

  private

  def new_instance
    @basecamp = Basecamp.new(logger)
  end
end
