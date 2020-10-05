# frozen_string_literal: true

class Controller
  def initialize(logger, basecamp, repo_api)
    @logger = logger
    @basecamp = basecamp
    @repo_api = repo_api
  end

  def valid_request?
    @repo_api.valid_request?
  end

  def process_request
    logger.debug "Request: #{@request}"
    resources = @basecamp.resources

    return unless resources

    state = @repo_api.state

    resources.each do |res|
      begin
        @basecamp.update_comments(res, @repo_api)
      rescue Error::BasecampError => e
        @logger.debug(e.message)
      end

    end
  end
end