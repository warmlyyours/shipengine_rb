# Changelog

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
