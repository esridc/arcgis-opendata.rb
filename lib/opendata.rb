require "client"

module Opendata

  # Returns a new Opendata::Client instance
  #
  # @param url [String] the base url to the open data API
  # @param options [Hash] assorted options for instantiating the Opendata::Client instance
  # @return [Object] the Opendata::Client instance
  class << self
    def new(url, options={})
      Client.new(url, options)
    end
  end
end
