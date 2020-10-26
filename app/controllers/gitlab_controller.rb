class GitlabController < ApplicationController

  def webhook
    logger.info "Params: #{params}"

    ENV.each { |k,v| logger.info "#{k} = #{v}" }

    # @basecamp = Basecamp.new(logger)
    # @basecamp.request = params

    # @gitlab = GitlabConnector.new(logger, params)
    # orchestrator = Orchestrator.new(logger, @basecamp, @gitlab)

    # return head(:bad_request) unless ctrl.valid_request?

    # ctrl.process_request
  end

end
