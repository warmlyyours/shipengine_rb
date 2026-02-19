# Changelog

## 1.0.0 (2026-02-19)


### ⚠ BREAKING CHANGES

* modernize SDK to v2.0.0 — Faraday 2.x, Ruby 3.4, full API coverage

### Features

* modernize SDK to v2.0.0 — Faraday 2.x, Ruby 3.4, full API coverage ([5941c14](https://github.com/warmlyyours/shipengine_rb/commit/5941c1417a8a60983ab99b4b53c7609eb916f303))


### Bug Fixes

* [SE-119] Get SDK build working and First Gem published :truck: ([dbba243](https://github.com/warmlyyours/shipengine_rb/commit/dbba243460e85fbe5b644078a933ca36c5f2c57d))
* change default timeout to 60s ([81bfe73](https://github.com/warmlyyours/shipengine_rb/commit/81bfe73feb0abc8a87aedb15e9b3935dd33d4da9))
* fixup CD ([fcb16ad](https://github.com/warmlyyours/shipengine_rb/commit/fcb16ada4628dbb330f3c33f0f5ba58bcfe4d8ed))
* Update publish to Gem API Key ([3f9c8e5](https://github.com/warmlyyours/shipengine_rb/commit/3f9c8e5eec8147e2fb1b38a114fa0e2ff24a5f9e))
* Update versioning and prune failed attempts from git ([5eb0f22](https://github.com/warmlyyours/shipengine_rb/commit/5eb0f227b8466f61ce3f8df3edef6cab5779dbd1))

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
