class GitlabController < ApplicationController

  def webhook
    # logger.info "Params: #{params}"

    basecamp = Basecamp.new(logger)
    basecamp.request = params

    merge = MergeRequest.new(logger, params)
    orchestrator = Orchestrator.new(logger, basecamp, merge)

    return head(:bad_request) unless orchestrator.valid_request?

    orchestrator.process_pull_request
  end

end
