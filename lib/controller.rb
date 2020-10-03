# frozen_string_literal: true

class Controller

  def initialize(request, repo)
    @request = request
    @basecamp = Basecamp.new
    @repo = repo
  end

  def authorization_uri
    @basecamp.authorization_uri
  end

  def authorize!(code)
    logger.info 'Fetching OAuth tokens from Basecamp'
    token = @basecamp.authorize! auth_code

    puts "Refresh token: #{token.refresh_token}"
    puts "Access token: #{token.access_token}"
    token
  end

  def process_request
    # TODO: Handle different MR states, open, close or update
    resources = @basecamp.resources(@request["object_attributes"]["description"])

    return unless resources

    resources.each do |res|
      puts res.inspect
    end
  end
end