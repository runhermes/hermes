# frozen_string_literal: true

class Orchestrator
  def initialize(logger, pull_request)
    @logger = logger
    @basecamp = Basecamp.new(logger)
    @basecamp.request = pull_request
    @pull_request = pull_request
  end

  def valid_request?
    @pull_request.valid?
  end

  def process_pull_request
    @logger.info "Getting basecamp resources from pull request #{@pull_request.full_name}"
    resources = @basecamp.resources
    @logger.info "Basecamp resources found in description: #{resources.count}"

    resources.each do |res|
      begin
        case res.type
        when "Todo"
          if found_keywords(res)
            @logger.info "Apply TODO workflow for resource #{res.type}##{res.id}"
            @basecamp.apply_todo_workflow(res, @pull_request)
          else
            @logger.info "No supported keyword found for #{res.type}##{res.id}"
          end
        end
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

  def found_keywords(resource)
    @logger.info "Checking if pull_request have required keyword"
    @pull_request.description.split('\n').each do |line|
      down_line = line.downcase
      SUPPORTED_PR_KEYWORDS.each do |keyword|
        return true if down_line.match?(/.*#{keyword}\s+#{resource.app_url}.*/)
      end
    end

    false
  end

  SUPPORTED_PR_KEYWORDS = [
    'close',
    'closes',
    'closed',
    'fix',
    'fixes',
    'fixed',
    'resolve',
    'resolves',
    'resolved',
  ]
end