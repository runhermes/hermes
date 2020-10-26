class GitlabController < ApplicationController

  def webhook
    logger.info "Params: #{params}"
    
    @basecamp = Basecamp.new(logger)
    @basecamp.request = params

    @gitlab = GitlabConnector.new(logger, params)
    orchestrator = Orchestrator.new(logger, @basecamp, @gitlab)

    return head(:bad_request) unless ctrl.valid_request?

    ctrl.process_request
  end

end
