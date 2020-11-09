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
    tokens = @basecamp.authorize! auth_code

    SettingsManager.update_tokens(tokens, logger)

    render plain: "Authentication successful"
  end

  private

  def new_instance
    @basecamp = Basecamp.new(logger)
  end
end
