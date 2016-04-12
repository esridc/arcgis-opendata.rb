require "client"

module Opendata

  # Factory method to instantiate an Opendata::Client instance
  class << self
    def new(url, options={})
      Client.new(url, options)
    end
  end
end
