require 'faraday'
require 'uri'

module Opendata

  VERSION = '0.0.2'.freeze

  class Client

    # Constructor for Opendata::Client instances
    # @param url [String] the base url to the open data API
    # @param options [Hash] assorted options for instantiating the Opendata::Client instance
    # @return [Object] the Opendata::Client instance which is a simple wrapper around a Faraday::Connection instance
    def initialize(url = nil, options = {})
      opts = options.merge(DEFAULT_HEADERS)
      @connection = Faraday.new(url, opts)
    end

    # Makes requests for 'logical collections' of Dataset resources (zero-to-many potential dataset resources)
    # @param params [Hash] query parameters for Dataset resources
    # @return [Object] Faraday::Response object
    def dataset_list(params = {})
      connection.get(DATASETS_API_PATH + param_to_query_string(params))
    end

    # Makes requests for a 'logical object' for a specific Dataset resource (zero-to-one potential dataset resources)
    # @param id [String] The dataset id
    # @param params [Hash] Additional request parameters
    def dataset_show(id, params = {})
      raise '#dataset_show must receive a dataset id' if id.nil?

      connection.get(DATASETS_API_PATH + "/#{id}" + param_to_query_string(params))
    end

    def param_to_query_string(params)
      adjusted_params = {}

      # 'flatten' the JSONAPI params
      params.each do |key, value|
        if value.respond_to?(:each)
          value.each do |nested_param, nested_value|
            key = "#{key}[#{nested_param}]"
            adjusted_params[key] = nested_value
          end
        else
          adjusted_params[key] = value
        end
      end

      query_string = URI.encode_www_form(adjusted_params)

      query_string == "" ? query_string : "?#{query_string}"
    end

    private
    
    attr_reader :connection

    DATASETS_API_PATH = '/api/v2/datasets'.freeze

    DEFAULT_HEADERS = {
      headers: {
        'Content-Type' => 'application/vnd.api+json',
        'User-Agent' => "ArcGIS Open Data Ruby Client v#{VERSION}"
      }
    }
  end
end
