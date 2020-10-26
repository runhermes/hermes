# frozen_string_literal: true

class Orchestrator
  def initialize(logger, basecamp, repo_client)
    @logger = logger
    @basecamp = basecamp
    @repo_client = repo_client
  end

  def valid_request?
    @repo_client.valid_request?
  end

  def process_request
    @logger.info "Getting basecamp resources from request"
    resources = @basecamp.resources

    state = @repo_client.state

    @logger.info "Update comments for each resource"
    resources.each do |res|
      begin
        @basecamp.update_comments(res, @repo_client)
      rescue Error::BasecampError => e
        @logger.info("Failed to update resource of type #{res.type} with id: #{res.id}")
        @logger.info(e.message)
      rescue StandarError => e
        @logger.info("Unknown error happened")
        @logger.info(e.message)
        @logger.info(e.backtrace)
      end
    end

    nil
  end
end