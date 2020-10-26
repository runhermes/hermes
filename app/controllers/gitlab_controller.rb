class GitlabController < ApplicationController

  def webhook
    logger.info "Params: #{params}"

    ENV.each { |k,v| logger.info "#{k} = #{v}" }

    basecamp = Basecamp.new(logger)
    basecamp.request = params

    gitlab = GitlabConnector.new(logger, params)
    orchestrator = Orchestrator.new(logger, basecamp, gitlab)

    return head(:bad_request) unless orchestrator.valid_request?

    orchestrator.process_request
  end

end
