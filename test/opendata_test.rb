require 'test_helper'

class OpendataTest < Minitest::Test
  def test_that_it_has_a_version_number
    assert_equal "0.0.1", ::Opendata::VERSION
  end

  def test_that_it_can_instantiate_client_instance
    assert_instance_of ::Opendata::Client, ::Opendata.new("https://opendata.arcgis.com") 
  end

  def test_that_client_class_converts_hash_params_to_query_string
    client = ::Opendata::Client.new("https://opendata.arcgis.com")
    query_string = client.param_to_query_string(q: 'census blocks', includes: 'organizations')

    assert_equal "?q=census+blocks&includes=organizations", query_string
  end

  def test_that_client_converts_nested_params_to_query_string
    client = ::Opendata::Client.new("https://opendata.arcgis.com")
    query_string = client.param_to_query_string(page: {size: 25, number: 2}, fields: { datasets: 'title,url,description' })

    assert_equal "?page%5Bsize%5D=25&page%5Bsize%5D%5Bnumber%5D=2&fields%5Bdatasets%5D=title%2Curl%2Cdescription", query_string
  end

  def test_that_client_can_handle_normal_and_nested_params
    client = ::Opendata::Client.new("https://opendata.arcgis.com")
    query_string = client.param_to_query_string(q: 'land value increase 2015',includes:'organizations',page:{size: 25, number: 2}, fields:{ datasets: 'title,url,description' })

    assert_equal "?q=land+value+increase+2015&includes=organizations&page%5Bsize%5D=25&page%5Bsize%5D%5Bnumber%5D=2&fields%5Bdatasets%5D=title%2Curl%2Cdescription", query_string
  end

  def test_that_client_can_handle_empty_params
    client = ::Opendata::Client.new("https://opendata.arcgis.com")
    query_string = client.param_to_query_string({})

    assert_equal "", query_string
  end

  def test_that_client_datasets_fetch_returns_faraday_response_instance
    client = ::Opendata::Client.new("https://opendata.arcgis.com")
    resp = client.dataset_list(q: 'parcels', page: { size: 15})

    assert_instance_of Faraday::Response, resp
  end

  def test_that_client_single_dataset_fetch_returns_faraday_response_instance
    client = ::Opendata::Client.new("https://opendata.arcgis.com")
    resp = client.dataset_show('c92b122901ad40ee897d36b1a21f3187_11')

    assert_instance_of Faraday::Response, resp
  end
end
