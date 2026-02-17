# Changelog

## [2.0.0] - 2026-02-17

### Breaking Changes

- **Ruby >= 3.4 required** (was >= 3.2.2)
- **Faraday upgraded from 1.x to 2.x** -- if you depend on Faraday internals or the old middleware namespace (`FaradayMiddleware`), you will need to update
- **Removed `hashie` runtime dependency** -- response parsing no longer uses `Hashie::Mash`; all domain files now use direct hash bracket access
- **Removed `faraday_middleware` runtime dependency** -- replaced by built-in Faraday 2.x JSON middleware and `faraday-retry`
- **`create_return_label` now requires `label_id` as the first parameter** -- signature changed from `(params, config)` to `(label_id, params, config)` to match the API path `POST /v1/labels/{label_id}/return`

### New Features

- **15 new API domains** with full CRUD operations:
  - Account (with images), Batches, Carrier Accounts (with settings), Documents,
    Downloads, Insurance, Manifests, Package Pickups, Package Types,
    Service Points, Shipments, Tags, Tokens, Warehouses (with settings), Webhooks
- **Expanded existing domains** with missing operations:
  - Addresses: `parse_address`
  - Carriers: `get_carrier_by_id`, `disconnect_carrier`, `add_funds_to_carrier`, `list_carrier_services`, `list_carrier_packages`, `list_carrier_options`
  - Labels: `list_labels`, `get_label_by_id`, `get_label_by_external_shipment_id`, `create_return_label`, `create_label_from_shipment_id`
  - Rates: `estimate_rates`, `get_rate_by_id`, `get_bulk_rates`
  - Tracking: `start_tracking`, `stop_tracking`
  - Shipments: `get_shipment_by_external_id`, `parse_shipment`, `get_shipment_rates`, `list_shipment_tags`, `update_shipment_tags`
  - Batches: `get_batch_by_external_id`, `add_shipments_to_batch`, `remove_shipments_from_batch`, `get_batch_errors`
  - Manifests: `get_manifest_request_by_id`
  - Warehouses: `update_warehouse_settings`
  - Carrier Accounts: `get_carrier_account_settings`, `update_carrier_account_settings`
  - Account: `list_account_images`, `get_account_image`, `create_account_image`, `update_account_image`, `delete_account_image`
  - Documents: `create_combined_label_document`
- **~100 total API operations** implemented (was 9 in v1.x)
- Added `PATCH` HTTP method support to `InternalClient`
- Custom middleware moved to `ShipEngine::Middleware::RaiseHttpException` namespace

### Bug Fixes

- Fixed `create_return_label` to use correct API path (`POST /v1/labels/{label_id}/return`)
- Fixed `add_insurance_funds` to use correct API path (`PATCH /v1/insurance/shipsurance/add_funds`)
- Removed invalid `Batches#update` method (no PUT endpoint exists in API)

### Improvements

- Verified API coverage against official [OpenAPI 3.0 spec](https://github.com/ShipEngine/shipengine-openapi)
- Compared implementation with [Python SDK](https://github.com/ShipEngine/shipengine-python) architecture
- Upgraded all dev/test dependencies to latest versions
- Updated CI to use `actions/checkout@v4` and Ruby 3.4 matrix
- Removed dead utility code (`pretty_print.rb`)
- Comprehensive API coverage audit document (`API_COVERAGE_AUDIT.md`)
- 115 tests with 644 assertions covering all endpoints

### Dependencies

- `faraday` ~> 2.0 (was >= 1.4)
- `faraday-retry` ~> 2.0 (new)
- Removed: `faraday_middleware`, `hashie`

## [1.0.5]

### Changes

- Added error code FundingSourceMissingConfiguration
- Added error code FundingSourceError

## [1.0.4](https://github.com/ShipEngine/shipengine-ruby/compare/v1.0.3...v1.0.4) (2024-01-17)

### Bug Fixes

- change default timeout to 60s ([81bfe73](https://github.com/ShipEngine/shipengine-ruby/commit/81bfe73feb0abc8a87aedb15e9b3935dd33d4da9))

## [1.0.3](https://github.com/ShipEngine/shipengine-ruby/compare/v1.0.2...v1.0.3) (2023-06-16)

### Bug Fixes

- Update publish to Gem API Key ([3f9c8e5](https://github.com/ShipEngine/shipengine-ruby/commit/3f9c8e5eec8147e2fb1b38a114fa0e2ff24a5f9e))
