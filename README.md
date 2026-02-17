# ShipEngine Rb

A comprehensive Ruby SDK for the [ShipEngine API](https://shipengine.com), including full parcel and LTL freight support.

Built on Faraday 2.x with automatic retries and rate-limit handling.

## Requirements

- Ruby >= 3.4

## Installation

Add to your Gemfile:

```ruby
gem 'shipengine_rb'
```

Then run:

```bash
bundle install
```

Or install directly:

```bash
gem install shipengine_rb
```

## Quick Start

```ruby
require 'shipengine_rb'

client = ShipEngineRb::Client.new('YOUR_API_KEY')

# Validate addresses
results = client.addresses.validate([{
  address_line1: '1 E 161 St',
  city_locality: 'The Bronx',
  state_province: 'NY',
  postal_code: '10451',
  country_code: 'US'
}])
```

## Resource-Based API

All operations are accessed through domain resources on the client:

```ruby
client = ShipEngineRb::Client.new('YOUR_API_KEY')

client.addresses       # Address validation and parsing
client.batches         # Batch operations
client.carriers        # Carrier listing, services, packages, options
client.carrier_accounts # Connect/disconnect carrier accounts
client.documents       # Combined label documents
client.downloads       # File downloads
client.insurance       # Shipsurance balance and funds
client.labels          # Create, void, list, and manage labels
client.ltl             # LTL freight quotes, pickups, tracking
client.manifests       # Manifest creation and retrieval
client.package_pickups # Schedule and manage pickups
client.package_types   # Custom package types
client.rates           # Rate estimation and retrieval
client.service_points  # Service point lookup
client.shipments       # Shipment CRUD, tagging, rates
client.tags            # Tag management
client.tokens          # Ephemeral tokens
client.tracking        # Package tracking
client.warehouses      # Warehouse management
client.webhooks        # Webhook management
```

Every method returns a raw parsed JSON hash for maximum flexibility.

## API Coverage

### Addresses

```ruby
client.addresses.validate(addresses_array)
client.addresses.parse({ text: "Ship to 525 S Winchester Blvd, San Jose CA 95128" })
```

### Labels

```ruby
client.labels.create_from_rate(rate_id, params)
client.labels.create_from_shipment_details(params)
client.labels.create_from_shipment_id(shipment_id, params)
client.labels.create_return_label(label_id, params)
client.labels.void(label_id)
client.labels.list(page: 1, page_size: 25)
client.labels.get_by_id(label_id)
client.labels.get_by_external_shipment_id(external_id)
```

### Carriers

```ruby
client.carriers.list
client.carriers.get_by_id(carrier_id)
client.carriers.disconnect(carrier_id)
client.carriers.add_funds(carrier_id, { currency: 'usd', amount: 25.00 })
client.carriers.list_services(carrier_id)
client.carriers.list_packages(carrier_id)
client.carriers.list_options(carrier_id)
```

### Rates

```ruby
client.rates.get_with_shipment_details(shipment_details)
client.rates.estimate(params)
client.rates.get_by_id(rate_id)
client.rates.bulk(params)
```

### Tracking

```ruby
client.tracking.track_by_label_id(label_id)
client.tracking.track(carrier_code, tracking_number)
client.tracking.start(carrier_code, tracking_number)
client.tracking.stop(carrier_code, tracking_number)
```

### Shipments

```ruby
client.shipments.list(page: 1)
client.shipments.create(params)
client.shipments.get_by_id(shipment_id)
client.shipments.update(shipment_id, params)
client.shipments.cancel(shipment_id)
client.shipments.add_tag(shipment_id, tag_name)
client.shipments.remove_tag(shipment_id, tag_name)
client.shipments.get_by_external_id(external_id)
client.shipments.parse(params)
client.shipments.get_rates(shipment_id)
client.shipments.list_tags(shipment_id)
client.shipments.update_tags(params)
```

### LTL Freight

```ruby
client.ltl.list_carriers
client.ltl.get_quote(carrier_id, params)
client.ltl.list_quotes
client.ltl.get_quote_by_id(quote_id)
client.ltl.schedule_pickup(params)
client.ltl.get_pickup(pickup_id)
client.ltl.update_pickup(pickup_id, params)
client.ltl.cancel_pickup(pickup_id)
client.ltl.track(tracking_number: 'LTL123')
```

### Batches

```ruby
client.batches.list
client.batches.create(params)
client.batches.get_by_id(batch_id)
client.batches.delete(batch_id)
client.batches.process(batch_id)
client.batches.get_by_external_id(external_id)
client.batches.add_shipments(batch_id, params)
client.batches.remove_shipments(batch_id, params)
client.batches.get_errors(batch_id)
```

### Webhooks

```ruby
client.webhooks.list
client.webhooks.create(params)
client.webhooks.get_by_id(webhook_id)
client.webhooks.update(webhook_id, params)
client.webhooks.delete(webhook_id)
```

### Warehouses

```ruby
client.warehouses.list
client.warehouses.create(params)
client.warehouses.get_by_id(warehouse_id)
client.warehouses.update(warehouse_id, params)
client.warehouses.delete(warehouse_id)
client.warehouses.update_settings(warehouse_id, params)
```

### Additional Resources

- **Account**: `client.account.get_settings`, `update_settings`, `list_images`, `get_image`, `create_image`, `update_image`, `delete_image`
- **Carrier Accounts**: `client.carrier_accounts.connect`, `disconnect`, `get_settings`, `update_settings`
- **Documents**: `client.documents.create_combined_label_document`
- **Downloads**: `client.downloads.download(subpath)`
- **Insurance**: `client.insurance.get_balance`, `add_funds`, `connect`, `disconnect`
- **Manifests**: `client.manifests.list`, `create`, `get_by_id`, `get_request_by_id`
- **Package Pickups**: `client.package_pickups.list`, `schedule`, `get_by_id`, `delete`
- **Package Types**: `client.package_types.list`, `create`, `get_by_id`, `update`, `delete`
- **Service Points**: `client.service_points.list`, `get_by_id`
- **Tags**: `client.tags.list`, `create`, `delete`, `rename`
- **Tokens**: `client.tokens.get_ephemeral_token`

## Configuration

```ruby
client = ShipEngineRb::Client.new(
  'YOUR_API_KEY',
  retries: 2,           # Number of retries on 429 (default: 1)
  timeout: 30_000,      # Request timeout in milliseconds (default: 60000)
  page_size: 25,        # Default page size (default: 50)
  base_url: 'https://api.shipengine.com' # API base URL
)
```

Per-request configuration overrides:

```ruby
client.carriers.list(config: { api_key: 'DIFFERENT_KEY', timeout: 10_000 })
```

## Error Handling

```ruby
begin
  client.labels.void('invalid-id')
rescue ShipEngineRb::Exceptions::ShipEngineError => e
  puts e.message
  puts e.code        # e.g. 'not_found'
  puts e.type        # e.g. 'system'
  puts e.source      # e.g. 'shipengine'
  puts e.request_id
end
```

## Documentation

### YARD API Docs

Generate browsable HTML documentation from the annotated source:

```bash
bundle exec rake yard
open doc/index.html
```

Or start a local documentation server:

```bash
yard server --reload
```

### Guides

Detailed guides with code samples and full JSON response examples are available in the [`docs/`](docs/) directory:

| Domain | Guide |
|--------|-------|
| [Configuration](docs/configuration.md) | Client setup, per-request overrides, error handling, retries |
| [Addresses](docs/addresses.md) | Validate and parse shipping addresses |
| [Carriers](docs/carriers.md) | List carriers, services, packages, options |
| [Labels](docs/labels.md) | Create, void, list, and manage shipping labels |
| [Rates](docs/rates.md) | Get rate estimates and shipment rates |
| [Tracking](docs/tracking.md) | Track packages by label ID or tracking number |
| [Shipments](docs/shipments.md) | Create, update, cancel, tag shipments |
| [LTL Freight](docs/ltl.md) | LTL carriers, quotes, pickups, tracking |
| [Batches](docs/batches.md) | Batch label operations |
| [Warehouses](docs/warehouses.md) | Warehouse CRUD and settings |
| [Webhooks](docs/webhooks.md) | Webhook management |
| [Tags](docs/tags.md) | Tag management |
| [Account](docs/account.md) | Account settings and images |
| [Carrier Accounts](docs/carrier_accounts.md) | Connect and configure carrier accounts |
| [Documents](docs/documents.md) | Combined label documents |
| [Downloads](docs/downloads.md) | File downloads |
| [Insurance](docs/insurance.md) | Shipsurance balance and funds |
| [Manifests](docs/manifests.md) | Carrier manifests |
| [Package Pickups](docs/package_pickups.md) | Schedule and manage pickups |
| [Package Types](docs/package_types.md) | Custom package types |
| [Service Points](docs/service_points.md) | Carrier service point lookup |
| [Tokens](docs/tokens.md) | Ephemeral token generation |

## License

MIT
