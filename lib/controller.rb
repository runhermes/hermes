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
    resources = @basecamp.resources(@request["object_attributes"]["description"])

    return unless resources

    resources.each do |res|
      puts res.inspect
    end
  end
end