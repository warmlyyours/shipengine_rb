# Changelog

## [0.2.0](https://github.com/warmlyyours/shipengine_rb/compare/v0.1.0...v0.2.0) (2026-06-02)


### Features

* **exceptions:** surface raw HTTP body/status/url on ShipEngineError ([cc49393](https://github.com/warmlyyours/shipengine_rb/commit/cc493938bfd02da911f3d368cda354c056695201))


### Bug Fixes

* ErrorCode.get_by_str returns original string for unknown codes ([0ecf693](https://github.com/warmlyyours/shipengine_rb/commit/0ecf69363d83ad5a9ac85ccc8d031afedf3367da))
* **ltl:** remove three undocumented GET methods that return 405 ([02e83b5](https://github.com/warmlyyours/shipengine_rb/commit/02e83b5e31ada0f3c59a3194745fbcdbe85723ee))
* **tracking:** POST /v1/tracking/{start,stop} requires params in the query string ([35968a7](https://github.com/warmlyyours/shipengine_rb/commit/35968a736afbfabee1d02af9e34901d1af23749c))

## 0.1.0 - Initial Release

A comprehensive Ruby SDK for the ShipEngine API with full parcel and LTL freight support.

### Highlights

- **Resource-based API**: Access domains via `client.labels.create(...)`, `client.tracking.track(...)`, etc.
- **Raw hash responses**: Every method returns parsed JSON hashes (symbol keys) for maximum flexibility
- **LTL freight support**: Full coverage of ShipEngine's LTL API (`/v-beta/ltl/`) including carriers, quotes, pickups, and tracking
- **Modern Ruby**: Built for Ruby >= 3.4
- **Faraday 2.x + http.rb**: Fast HTTP stack with persistent connections, automatic 429 rate-limit retries, and `Retry-After` header support
- **Pagination helpers**: Built-in `list_all` (lazy enumerator) and `list_each` for auto-paginated iteration
- **Thread-safe configuration**: Immutable, frozen config objects with per-request override support
- **Idempotency**: `Idempotency-Key` header support on any request
- **Configurable logging**: Optional request/response logger
- **99% test coverage**: 255 tests, 652 assertions, 98.88% line coverage, 88.24% branch coverage
- **Comprehensive documentation**: YARD annotations on all public APIs + 22 detailed markdown guides with code samples and JSON response examples

### API Coverage

Full parcel API coverage across 21 domains:

- Addresses (validate, parse)
- Batches (CRUD, process, add/remove shipments, errors)
- Carriers (list, services, packages, options, funds)
- Carrier Accounts (connect, disconnect, settings)
- Documents (combined labels)
- Downloads
- Insurance (balance, funds, connect/disconnect)
- Labels (create from rate/shipment/ID, void, list, return labels)
- LTL Freight (carriers, quotes, pickups, tracking)
- Manifests (list, create, get by ID/request ID)
- Package Pickups (list, schedule, get, delete)
- Package Types (CRUD)
- Rates (estimate, get, bulk, shipment details)
- Service Points (list, get)
- Shipments (CRUD, cancel, tag, parse, rates)
- Tags (CRUD, rename)
- Tokens (ephemeral)
- Tracking (by label ID, by carrier code + tracking number, start/stop)
- Warehouses (CRUD, settings)
- Webhooks (CRUD)
- Account (settings, images)
