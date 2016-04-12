require 'version'
require 'faraday'
require 'uri'

module Opendata

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
    # @option params [String] :q The query string for searching against datasets
    # @option params [String] :include Comma-separate list of related resources to include. valid options are: 'organizations', 'groups', 'sites', 'items'
    # @option params [String] :sort Sort criteria for the request. prepend a '-' to make the sort descending.
    # @option params [Hash] :page Paging on the request. Use page[size] for the number of results per page and  page[number] for the page number 
    # @option params [Hash] :fields The attribute subset you want returned for each object. 
    #
    # @example Search for census datasets, 25 per page and include their related organizations and sites
    #   client = Opendata.new('https://opendata.arcgis.com')
    #   client.dataset_list(q: 'census', page: { size: 25 }, include: 'organizations,sites')
    # @example Search for parcel datasets, second page, and include their related organizations and filter the dataset fields to title and url
    #   client = Opendata.new('https://opendata.arcgis.com')
    #   client.dataset_list(q: 'parcels', page: { number: 2 }, include: 'organizations', fields: { datasets: 'title,url'})
    #
    # @return [Object] Faraday::Response object
    def dataset_list(params = {})
      connection.get(dataset_list_url(params))
    end

    # Makes requests for 'logical collections' of Dataset resources (zero-to-many potential dataset resources)
    # @param params [Hash] query parameters for Dataset resources
    # @example Get the request url for a search for census datasets, 25 per page and include their related organizations and sites
    #   client = Opendata.new('https://opendata.arcgis.com')
    #   client.dataset_list_url(q: 'census', page: { size: 25 }, include: 'organizations,sites')
    #   #=> "/api/v2/datasets?q=census&page%5Bsize%5D=25&include=organizations%2Csites"
    #
    # @return [String] request url based on the parameters specfied
    def dataset_list_url(params = {})
      DATASETS_API_PATH + param_to_query_string(params)
    end

    # Makes requests for a 'logical object' for a specific Dataset resource (zero-to-one potential dataset resources)
    # @param id [String] The dataset id
    # @param params [Hash] Additional request parameters
    #
    # @example Retrive a dataset and related organizations and sites
    #   client = Opendata.new('https://opendata.arcgis.com')
    #   client.dataset_show('c92b122901ad40ee897d36b1a21f3187_11', include: 'organizations,sites')
    #
    # @example Retrive a dataset and specify a subset of fields (title,url,description,thumbnail)
    #   client = Opendata.new('https://opendata.arcgis.com')
    #   client.dataset_show('c92b122901ad40ee897d36b1a21f3187_11', fields: { datasets: 'title,url,description,thumbnail'})
    # @return [Object] Faraday::Response object
    def dataset_show(id, params = {})
      raise '#dataset_show must receive a dataset id' if id.nil?
      connection.get(dataset_show_url(id, params))
    end

    # Returns the url based on the id and url parameters specified
    # @param id [String] The dataset id
    # @param params [Hash] Additional request parameters
    # @example Get the requets url for retrieving a single dataset and its related organizations and sites
    #   client = Opendata.new('https://opendata.arcgis.com')
    #   client.dataset_show_url('c92b122901ad40ee897d36b1a21f3187_11', include: 'organizations,sites')
    #   #=> "/api/v2/datasets/c92b122901ad40ee897d36b1a21f3187_11?include=organizations%2Csites"
    # @return [String] request url based on id and parameters specified
    def dataset_show_url(id, params = {})
      DATASETS_API_PATH + "/#{id}" + param_to_query_string(params)
    end

    private

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
