# Changelog

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
