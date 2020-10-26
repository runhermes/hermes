class GitlabController < ApplicationController

  def webhook
    logger.info "Params: #{params}"

    basecamp = Basecamp.new(logger)
    basecamp.request = params

    gitlab_client = GitlabClient.new(logger, params)
    orchestrator = Orchestrator.new(logger, basecamp, gitlab_client)

    return head(:bad_request) unless orchestrator.valid_request?

    orchestrator.process_request
  end

end
