# frozen_string_literal: true

class Controller
  def initialize(request, basecamp, repo_api)
    @request = request
    @basecamp = basecamp
    @repo_api = repo_api
  end

  def valid_request?
    @repo_api.valid_request?
  end

  def process_request
    # TODO: Handle different MR states, open, close or update
    puts "Request:\n #{@request}"
    resources = @basecamp.resources

    return unless resources

    state = @repo_api.state

    resources.each do |res|
      comments = @basecamp.update_comments(res, @repo_api)
    end
  end
end