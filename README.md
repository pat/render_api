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

Returned response objects can be enumerated upon when a list of records are returned, and also can provide rate-limit details via `rate_limit`, `rate_limit_remaining`, and `rate_limit_reset` methods.

The response objects respond to underscored versions of the attribute names - e.g. a service responds to `auto_deploy` with the value from the underlying hash for the key `autoDeploy`. Timestamp strings are automatically converted to Time objects, and nested hashes are also provided as these utility objects.

Also: when the response objects are from a list, they respond to `cursor`, for use with pagination.

### Creating a client

```ruby
client = RenderAPI.client(api_key)
```

### Services

```ruby
client.services.list(limit: nil, cursor: nil, filters: nil)
```

```ruby
services = client.services.list(limit: 20)

puts services.rate_limit, services.rate_limit_remaining

services.each do |service|
  puts service.id
  puts service.cursor
  puts service.service_details.build_command
end
```

### Deploys

```ruby
client.deploys.list(service_id, limit: nil, cursor: nil, filters: nil)
client.deploys.create(service_id, clear_cache: "do_not_clear")
client.deploys.find(service_id, deploy_id)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests, and `bundle exec rubocop` to confirm linting and code structure. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pat/render_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/pat/render_api/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Render API project's codebase and other repository features is expected to follow the [code of conduct](https://github.com/pat/render_api/blob/main/CODE_OF_CONDUCT.md).
