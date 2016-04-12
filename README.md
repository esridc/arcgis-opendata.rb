# Opendata

## Installation

Add this line to your application's Gemfile:

Reference the latest source directly
```ruby
gem "arcgis-opendata", :git => "git://github.com/esridc/arcgis-opendata.rb.git", require: 'opendata'
```

From rubygems.org
```ruby
gem 'arcgis-opendata', require: 'opendata'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arcgis-opendata

## Usage

The main class the gem provides is `Opendata::Client`, which can be used to query and fetch
resources from the ArcGIS Open Data API

Instantiate an Opendata::Client instance
```ruby
client = Opendata::Client.new('https://opendata.arcgis.com')
```

You can also instantiate an instance directly from the Opendata module
```ruby
client = Opendata.new('https://opendata.arcgis.com')
```

### Example Dataset Queries

Search Parameters are JSONAPI compliant. To learn more about the JSONAPI parameters go to their section
about [fetching data](http://jsonapi.org/format/#fetching) at jsonapi.org

Parameters supported for `dataset_list`

| Parameter | Type | Description | Usage |
| --------- | ---- | ----------- | ----- |
| q         | String | query to perform against the datasets resource | `client#dataset_list(q: 'census')` |
| sort      | String | specifies sort criteria. prepend with a '-' to signify a descending sort| `client#dataset_list(sort: '-updated_at')` |
| include   | String | comma-separate list of resources to 'side-load' | `client#dataset_list(include: 'organizations,sites')` |
| fields    | nested | allows the client to specify a subset of attributes to be returned by the API | `client#dataset_list(fields: { datasets: 'title,url'})` |
| filter    | nested | filter the datasets on filterable attributes | `client#dataset_list(filter: { content: 'spatial dataset'})` |
| page      | nested | specify paging parameters. | `client#dataset_list(page: { size: 25, number: 2})`

Parameters supported for `dataset_show`

| Parameter | Type | Description | Usage |
| --------- | ---- | ----------- | ----- |
| include   | String | comma-separate list of resources to 'side-load' | `client#dataset_list(include: 'organizations,sites')` |
| fields    | nested | allows the client to specify a subset of attributes to be returned by the API | `client#dataset_list(fields: { datasets: 'title,url'})` |


Make queries for datasets
```ruby
client = Opendata.new('https://opendata.arcgis.com')

response = client.dataset_list(q: 'census', page: { size: 25}, include: 'organizations')
# => returns a Faraday::Response object
```

Fetch a single dataset
```ruby
client = Opendata.new('https://opendata.arcgis.com')

response = client.dataset_show('4df13_11', include: 'organizations,groups')
# => returns a Faraday::Response object
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. ~~You can also run `bin/console` for an interactive prompt that will allow you to experiment.~~ `bin/console` is currently not working

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `client.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/opendata.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

