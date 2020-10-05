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
    @logger.debug "Processing request"
    @logger.debug "Getting basecamp resources from request"
    resources = @basecamp.resources

    state = @repo_api.state

    @logger.debug "Update comments for each resource"
    resources.each do |res|
      begin
        @basecamp.update_comments(res, @repo_api)
      rescue Error::BasecampError => e
        @logger.debug(e.message)
      end
    end
  end
end