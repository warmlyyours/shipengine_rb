# Changelog

## 1.0.0 (2026-02-17)


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

First release of `shipengine_rb`, an independent Ruby SDK for the ShipEngine API.

### Highlights

- **New gem identity**: `shipengine_rb` with `ShipEngineRb` namespace, fully independent from the official `shipengine` gem
- **Resource-based API**: Access domains via `client.labels.create(...)`, `client.tracking.track(...)`, etc. instead of flat method delegations
- **All raw hash responses**: Every method returns parsed JSON hashes for maximum flexibility -- no typed response models
- **LTL freight support**: Full coverage of ShipEngine's LTL API (`/v-beta/ltl/`) including carriers, quotes, pickups, and tracking
- **Modern Ruby**: Requires Ruby >= 3.4
- **Faraday 2.x**: Built on Faraday 2.x with `faraday-retry` for automatic 429 rate-limit handling

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
