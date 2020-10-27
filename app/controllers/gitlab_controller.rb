class GitlabController < ApplicationController

  def webhook
    merge = MergeRequest.new(logger, params)

    return head(:bad_request) unless merge.valid?

    orchestrator = Orchestrator.new(logger, merge)

    orchestrator.process_pull_request
  end

end
