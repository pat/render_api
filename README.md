# Render API

A Ruby interface for [the render.com API](https://render.com/docs/api).

**Please note**: this gem is currently a proof-of-concept and does not support all of the API's endpoints yet - what's covered below in Usage is what's available right now. Full support is definitely the plan, and pull requests are welcome.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "render_api"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install render_api

## Usage

```ruby
client = RenderAPI.client(api_key)
client.services.list(limit: nil, cursor: nil, filters: nil)
client.deploys.list(service_id, limit: nil, cursor: nil, filters: nil)
client.deploys.create(service_id, clear_cache: "do_not_clear")
```

The returned response object can be enumerated upon when a list of records are returned, and also can provide rate-limit details via `rate_limit`, `rate_limit_remaining`, and `rate_limit_reset`.

The data objects respond to underscored versions of the attribute names - e.g. a service responds to `auto_deploy` even though the underlying hash has the key `autoDeploy`. Timestamp strings are automatically converted to Time objects, and nested hashes are also provided as objects.

WHen the data objects are from a list, they also respond to `cursor`, for use with pagination.

```ruby
services = client.services.list(limit: 20)
services.each do |service|
  puts service.id
  puts service.cursor
  puts service.service_details.build_command
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests, and `bundle exec rubocop` to confirm linting and code structure. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pat/render_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/pat/render_api/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Render API project's codebase and other repository features is expected to follow the [code of conduct](https://github.com/pat/render_api/blob/main/CODE_OF_CONDUCT.md).
