require 'opendata/version'
require 'faraday'
require 'uri'

module Opendata
  class Client
    
    def initialize(url = nil, options = {})
      opts = options.merge(DEFAULT_HEADERS)
      @connection = Faraday.new(url, opts)
    end

    # For making requets at /api/v2/datasets
    def dataset_list(params = {})
      connection.get(DATASETS_API_PATH + param_to_query_string(params))
    end

    # For making requests at /api/v2/datasets/{:id}
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
        'User-Agent' => "ArcGIS Open Data Ruby Client v#{Opendata::VERSION}"
      }
    }
  end
end
