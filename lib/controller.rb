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
    @logger.info "Processing request"
    @logger.info "Getting basecamp resources from request"
    resources = @basecamp.resources

    state = @repo_api.state

    @logger.info "Update comments for each resource"
    resources.each do |res|
      begin
        @basecamp.update_comments(res, @repo_api)
      rescue Error::BasecampError => e
        @logger.info("Failed to update resource of type #{res.type} with id: #{res.id}")
        @logger.info(e.message)
      rescue StandarError => e
        @logger.info("Unknown error happened")
        @logger.info(e.message)
        @logger.info(e.backtrace)
      end
    end
  end
end