# frozen_string_literal: true

class Orchestrator
  def initialize(logger, basecamp, pull_request)
    @logger = logger
    @basecamp = basecamp
    @pull_request = pull_request
  end

  def valid_request?
    @pull_request.valid?
  end

  def process_pull_request
    @logger.info "Getting basecamp resources from request"
    resources = @basecamp.resources

    @logger.info "Apply TODO workflow for each resource"
    resources.each do |res|
      begin
        @basecamp.apply_todo_workflow(res, @pull_request)
      rescue Error::BasecampError => e
        @logger.info("Failed to update #{res.type}##{res.id}")
        @logger.info(e.message)
      rescue Error::GitlabError => e
        @logger.info("Failed to handle request: #{@pull_request.inspect}")
        @logger.info(e.message)
      rescue StandardError => e
        @logger.info("Unknown error happened")
        @logger.info(e.message)
        @logger.info(e.backtrace)
      end
    end

    nil
  end
end