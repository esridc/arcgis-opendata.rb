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

    assert_equal "q=census+blocks&includes=organizations", query_string
  end
end
