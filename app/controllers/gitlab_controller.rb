class GitlabController < ApplicationController

  before_action :new_instance

  def webhook
      @basecamp.request = params
      @gitlab = GitlabConnector.new(params)
      orchestrator = Orchestrator.new(logger, @basecamp, @gitlab)

      return head(:bad_request) unless ctrl.valid_request?

      ctrl.process_request
  end
end
