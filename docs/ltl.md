# LTL Freight

Less-Than-Truckload (LTL) freight shipping. List LTL carriers, get quotes, schedule and manage pickups, and track LTL shipments. API base: `/v-beta/ltl/`.

## list_carriers

List all LTL carriers connected to the account. Carrier data includes embedded services, options, and package types.

**Method:** `client.ltl.list_carriers(config: {})`

**API Endpoint:** `GET /v-beta/ltl/carriers`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| config | Hash | No | Per-request config overrides (e.g. idempotency_key) |

### Example

```ruby
response = client.ltl.list_carriers
```

### Response

```json
{
  "carriers": [
    {
      "carrier_id": "ltl-1",
      "name": "R+L Carriers"
    }
  ]
}
```

---

## get_quote

Request an LTL freight quote from a specific carrier. Provide origin, destination, and package details.

**Method:** `client.ltl.get_quote(carrier_id, params, config: {})`

**API Endpoint:** `POST /v-beta/ltl/quotes/:carrier_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_id | String | Yes | The LTL carrier ID (e.g. "ltl-1") |
| params | Hash | Yes | Quote request body with `origin`, `destination`, `packages` |
| config | Hash | No | Per-request config overrides |

### params structure

| Name | Type | Required | Description |
|------|------|----------|-------------|
| origin | Hash | Yes | Origin address/location |
| destination | Hash | Yes | Destination address/location |
| packages | Array | Yes | Array of package details |

### Example

```ruby
params = {
  origin: {},
  destination: {},
  packages: []
}
response = client.ltl.get_quote('ltl-1', params)
```

### Response

```json
{
  "quote_id": "q-1",
  "total": {
    "amount": 250.00
  }
}
```

---

## list_quotes

List LTL quotes with optional filtering and pagination.

**Method:** `client.ltl.list_quotes(params = {}, config: {})`

**API Endpoint:** `GET /v-beta/ltl/quotes`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | No | Query params for filtering and pagination (e.g. page, page_size) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.ltl.list_quotes
# or with pagination:
response = client.ltl.list_quotes(page: 1, page_size: 25)
```

### Response

```json
{
  "quotes": []
}
```

---

## get_quote_by_id

Get a specific LTL quote by ID. Returns quote details including rate, carrier, and shipment info.

**Method:** `client.ltl.get_quote_by_id(quote_id, config: {})`

**API Endpoint:** `GET /v-beta/ltl/quotes/:quote_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| quote_id | String | Yes | The unique identifier of the LTL quote |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.ltl.get_quote_by_id('q-1')
```

### Response

```json
{
  "quote_id": "q-1"
}
```

---

## schedule_pickup

Schedule an LTL freight pickup. Provide quote ID and desired pickup date.

**Method:** `client.ltl.schedule_pickup(params, config: {})`

**API Endpoint:** `POST /v-beta/ltl/pickups`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Pickup scheduling details |
| config | Hash | No | Per-request config overrides |

### params structure

| Name | Type | Required | Description |
|------|------|----------|-------------|
| quote_id | String | Yes | The quote ID to schedule pickup for |
| pickup_date | String | Yes | Desired pickup date (e.g. "2026-02-20") |

### Example

```ruby
params = {
  quote_id: 'q-1',
  pickup_date: '2026-02-20'
}
response = client.ltl.schedule_pickup(params)
```

### Response

```json
{
  "pickup_id": "p-1"
}
```

---

## get_pickup

Get an LTL pickup by ID. Returns pickup details including status, window, and carrier info.

**Method:** `client.ltl.get_pickup(pickup_id, config: {})`

**API Endpoint:** `GET /v-beta/ltl/pickups/:pickup_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| pickup_id | String | Yes | The unique identifier of the pickup |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.ltl.get_pickup('p-1')
```

### Response

```json
{
  "pickup_id": "p-1"
}
```

---

## update_pickup

Update an existing LTL pickup. Modify pickup date or other scheduling details.

**Method:** `client.ltl.update_pickup(pickup_id, params, config: {})`

**API Endpoint:** `PUT /v-beta/ltl/pickups/:pickup_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| pickup_id | String | Yes | The unique identifier of the pickup to update |
| params | Hash | Yes | Updated pickup details |
| config | Hash | No | Per-request config overrides |

### params structure

| Name | Type | Required | Description |
|------|------|----------|-------------|
| pickup_date | String | No | New pickup date (e.g. "2026-02-21") |

### Example

```ruby
params = { pickup_date: '2026-02-21' }
response = client.ltl.update_pickup('p-1', params)
```

### Response

```json
{
  "pickup_id": "p-1"
}
```

---

## cancel_pickup

Cancel an LTL pickup.

**Method:** `client.ltl.cancel_pickup(pickup_id, config: {})`

**API Endpoint:** `DELETE /v-beta/ltl/pickups/:pickup_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| pickup_id | String | Yes | The unique identifier of the pickup to cancel |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.ltl.cancel_pickup('p-1')
```

### Response

Returns HTTP 204 No Content with an empty body.

---

## track

Track an LTL shipment. Provide tracking number and optionally carrier code.

**Method:** `client.ltl.track(params = {}, config: {})`

**API Endpoint:** `GET /v-beta/ltl/tracking`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Tracking query params |
| config | Hash | No | Per-request config overrides |

### params structure

| Name | Type | Required | Description |
|------|------|----------|-------------|
| tracking_number | String | Yes | The tracking number (e.g. "LTL123") |
| carrier_code | String | No | Carrier code for disambiguation |

### Example

```ruby
response = client.ltl.track({ tracking_number: 'LTL123' })
```

### Response

```json
{
  "tracking_number": "LTL123",
  "status": "in_transit"
}
```
