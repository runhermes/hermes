# frozen_string_literal: true

module Basecamp
  module API

    def self.headers
      {
        :Authorization => ::Basecamp::Configuration.access_token
      }
    end
    
    def self.find_links(text)
      links = Uri.extract(text)
  
      links.select { |link| link.start_with?('https://3.basecamp.com') }.
        map { |link| link.sub('3.basecamp.com', '3.basecampapi.com') }
    end
  
    def self.get_resources(description)
      links = self.find_links(description)
      
      links.map do |link|
        response = HTTParty.get(link)
        
        Resource.new(response)
      end
    end
  
    def self.get_comments(resource)
      response = HTTParty.get(resource.comments_url)
    end
  end
end