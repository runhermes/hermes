# frozen_string_literal: true

require 'uri'

class BasecampAccessor

    def self.find_links(text)
      links = URI.extract(text)
  
      links.select { |link| link.start_with?('https://3.basecamp.com') }
    end
  
    def self.resources(description)
      links = self.find_links(description)

      resources = links.map { |link| Camper.resource(link) }
    end
  
    def self.get_comments(resource)
      response = HTTParty.get(resource.comments_url)
    end
end