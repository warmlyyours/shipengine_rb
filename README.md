[![ShipEngine](https://shipengine.github.io/img/shipengine-logo-wide.png)](https://shipengine.com)

ShipEngine Ruby SDK
===================
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/ShipEngine/shipengine-ruby/CI.yaml?label=shipengine-ruby&logo=github)
![GitHub](https://img.shields.io/github/license/ShipEngine/shipengine-ruby?color=teal)

The Official Ruby SDK for [ShipEngine API](https://shipengine.com) offering low-level access as well as convenience methods.

Requirements
============
- Ruby >= 3.4

Quick Start
===========

Install the ShipEngine SDK Gem via [RubyGems](https://rubygems.org/gems/shipengine_sdk)
```bash
gem install shipengine_sdk
```
- The only configuration requirement is an [API Key](https://www.shipengine.com/docs/auth/#api-keys).

```ruby
require "shipengine"

api_key = ENV["SHIPENGINE_API_KEY"]

shipengine = ShipEngine::Client.new(api_key)
```

Methods
-------

### Addresses
* `validate_addresses(addresses, config)` - Validate an array of addresses.
* `parse_address(text, config)` - Parse an address from unstructured text.

### Carriers
* `list_carriers(config:)` - List all carriers.
* `get_carrier_by_id(carrier_id, config:)` - Get a carrier by ID.
* `disconnect_carrier(carrier_id, config:)` - Disconnect a carrier.
* `add_funds_to_carrier(carrier_id, amount, config:)` - Add funds to a carrier.
* `list_carrier_services(carrier_id, config:)` - List carrier services.
* `list_carrier_packages(carrier_id, config:)` - List carrier packages.
* `list_carrier_options(carrier_id, config:)` - List carrier options.

### Labels
* `create_label_from_rate(rate_id, params, config)` - Create a label from a rate.
* `create_label_from_shipment_details(params, config)` - Create a label from shipment details.
* `create_label_from_shipment_id(shipment_id, params, config)` - Create a label from an existing shipment ID.
* `void_label_with_label_id(label_id, config)` - Void a label.
* `list_labels(params, config)` - List labels.
* `get_label_by_id(label_id, config)` - Get a label by ID.
* `get_label_by_external_shipment_id(external_shipment_id, config)` - Get a label by external shipment ID.
* `create_return_label(label_id, params, config)` - Create a return label for an existing label.

### Rates
* `get_rates_with_shipment_details(shipment_details, config)` - Get rates.
* `estimate_rates(shipment_details, config)` - Estimate rates.
* `get_rate_by_id(rate_id, config)` - Get a rate by ID.
* `get_bulk_rates(params, config)` - Get bulk rates.

### Tracking
* `track_using_label_id(label_id, config)` - Track by label ID.
* `track_using_carrier_code_and_tracking_number(carrier_code, tracking_number, config)` - Track by carrier code and tracking number.
* `start_tracking(carrier_code, tracking_number, config)` - Start tracking a package.
* `stop_tracking(carrier_code, tracking_number, config)` - Stop tracking a package.

### Shipments
* `list_shipments(params, config:)` - List shipments.
* `create_shipments(params, config:)` - Create shipments.
* `get_shipment_by_id(shipment_id, config:)` - Get a shipment by ID.
* `get_shipment_by_external_id(external_shipment_id, config:)` - Get a shipment by external ID.
* `update_shipment(shipment_id, params, config:)` - Update a shipment.
* `cancel_shipment(shipment_id, config:)` - Cancel a shipment.
* `tag_shipment(shipment_id, tag_name, config:)` - Tag a shipment.
* `untag_shipment(shipment_id, tag_name, config:)` - Untag a shipment.
* `list_shipment_tags(shipment_id, config:)` - List tags for a shipment.
* `update_shipment_tags(params, config:)` - Bulk update shipment tags.
* `get_shipment_rates(shipment_id, params, config:)` - Get rates for a shipment.
* `parse_shipment(params, config:)` - Parse shipping info from unstructured text.

### Batches
* `list_batches(params, config:)` - List batches.
* `create_batch(params, config:)` - Create a batch.
* `get_batch_by_id(batch_id, config:)` - Get a batch by ID.
* `get_batch_by_external_id(external_batch_id, config:)` - Get a batch by external ID.
* `delete_batch(batch_id, config:)` - Delete a batch.
* `process_batch(batch_id, params, config:)` - Process a batch.
* `add_shipments_to_batch(batch_id, params, config:)` - Add shipments to a batch.
* `remove_shipments_from_batch(batch_id, params, config:)` - Remove shipments from a batch.
* `get_batch_errors(batch_id, config:)` - Get batch errors.

### Webhooks
* `list_webhooks(config:)` - List webhooks.
* `create_webhook(params, config:)` - Create a webhook.
* `get_webhook_by_id(webhook_id, config:)` - Get a webhook by ID.
* `update_webhook(webhook_id, params, config:)` - Update a webhook.
* `delete_webhook(webhook_id, config:)` - Delete a webhook.

### Warehouses
* `list_warehouses(config:)` - List warehouses.
* `create_warehouse(params, config:)` - Create a warehouse.
* `get_warehouse_by_id(warehouse_id, config:)` - Get a warehouse by ID.
* `update_warehouse(warehouse_id, params, config:)` - Update a warehouse.
* `delete_warehouse(warehouse_id, config:)` - Delete a warehouse.
* `update_warehouse_settings(warehouse_id, params, config:)` - Update warehouse settings.

### Tags
* `list_tags(config:)` - List tags.
* `create_tag(tag_name, config:)` - Create a tag.
* `delete_tag(tag_name, config:)` - Delete a tag.
* `rename_tag(tag_name, new_tag_name, config:)` - Rename a tag.

### Manifests
* `list_manifests(params, config:)` - List manifests.
* `create_manifest(params, config:)` - Create a manifest.
* `get_manifest_by_id(manifest_id, config:)` - Get a manifest by ID.
* `get_manifest_request_by_id(request_id, config:)` - Get a manifest request by ID.

### Package Types
* `list_package_types(config:)` - List custom package types.
* `create_package_type(params, config:)` - Create a custom package type.
* `get_package_type_by_id(package_id, config:)` - Get a package type by ID.
* `update_package_type(package_id, params, config:)` - Update a package type.
* `delete_package_type(package_id, config:)` - Delete a package type.

### Package Pickups
* `list_package_pickups(params, config:)` - List package pickups.
* `schedule_pickup(params, config:)` - Schedule a pickup.
* `get_pickup_by_id(pickup_id, config:)` - Get a pickup by ID.
* `delete_pickup(pickup_id, config:)` - Delete a pickup.

### Service Points
* `list_service_points(params, config:)` - List service points.
* `get_service_point_by_id(carrier_code, country_code, service_point_id, config:)` - Get a service point by ID.

### Insurance
* `get_insurance_balance(config:)` - Get insurance balance.
* `add_insurance_funds(params, config:)` - Add funds to insurance balance.
* `connect_insurance(config:)` - Connect Shipsurance.
* `disconnect_insurance(config:)` - Disconnect Shipsurance.

### Tokens
* `get_ephemeral_token(config:)` - Get an ephemeral token.

### Account
* `get_account_settings(config:)` - Get account settings.
* `update_account_settings(params, config:)` - Update account settings.
* `list_account_images(config:)` - List account images.
* `get_account_image(image_id, config:)` - Get an account image by ID.
* `create_account_image(params, config:)` - Create an account image.
* `update_account_image(image_id, params, config:)` - Update an account image.
* `delete_account_image(image_id, config:)` - Delete an account image.

### Carrier Accounts
* `connect_carrier_account(carrier_name, params, config:)` - Connect a carrier account.
* `disconnect_carrier_account(carrier_name, carrier_id, config:)` - Disconnect a carrier account.
* `get_carrier_account_settings(carrier_name, carrier_id, config:)` - Get carrier account settings.
* `update_carrier_account_settings(carrier_name, carrier_id, params, config:)` - Update carrier account settings.

### Documents
* `create_combined_label_document(params, config:)` - Create a combined label document.

### Downloads
* `download_file(subpath, config:)` - Download a file.

Contributing
============

Install dependencies
--------------------
- You will need to `gem install bundler` before using the following command to install dependencies from the Gemfile.
```bash
./bin/setup
```

Committing
-------------------------
This project adheres to the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.

Pre-Commit/Pre-Push Hooks
-------------------------
This project makes use of [Overcommit](https://github.com/sds/overcommit#usage) to enforce `pre-commit/push hooks`.
Overcommit will be downloaded and initialized as part of running the `./bin/setup` script, as outlined in the previous section.

- From then on when you commit code `rake lint` will run, and when you push code `rake test` and `rake lint` will run.
Upon failure of either of these, you can run `rake fix` to auto-fix lint issues and format code, and re-commit/push.

Testing & Development
---------------------
- While you are writing tests as you contribute code you can run tests ad-hoc via `rake` using the following command:
```bash
rake test
```
- You can run tests and have them re-run when you save changes to a given file with `guard`.
```bash
guard
```
Lastly, you can `format code & auto-fix lint errors` with the following:
```bash
rake fix
```

> Note: `guard` also provides a repl after tests run for quick repl development.

Repl Development
----------------
- You can start a `pry` repl that already has `shipengine` required by running the following command.
```bash
./bin/console
```

Publishing
-------------------------
Publishing new versions of the SDK to [RubyGems](https://rubygems.org/) is handled on GitHub via the [Release Please](https://github.com/googleapis/release-please) GitHub Actions workflow. Learn more about about Release PRs, updating the changelog, and commit messages [here](https://github.com/googleapis/release-please#how-should-i-write-my-commits).
