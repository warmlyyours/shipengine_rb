# Manifests

Create and manage carrier manifests. Manifests are used to close out a day's shipments with carriers. API path: `/v1/manifests`.

## list

List manifests, optionally filtered and paginated.

**Method:** `client.manifests.list(params = {}, config: {})`

**API Endpoint:** `GET /v1/manifests`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | No | Query params (page, page_size, carrier_id, created_at_start, etc.) |
| config | Hash | No | Per-request config overrides (e.g. idempotency_key) |

### Example

```ruby
response = client.manifests.list
# or with pagination:
response = client.manifests.list(page: 1, page_size: 25)
```

### Response

```json
{
  "manifests": [
    {
      "manifest_id": "man-1",
      "carrier_id": "se-carrier-1"
    }
  ],
  "total": 1,
  "page": 1,
  "pages": 1
}
```

---

## create

Create a new manifest for a carrier. Specify carrier, warehouse, and ship date.

**Method:** `client.manifests.create(params, config: {})`

**API Endpoint:** `POST /v1/manifests`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Manifest creation details |
| config | Hash | No | Per-request config overrides |

### params structure

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_id | String | Yes | The carrier ID |
| warehouse_id | String | Yes | The warehouse ID |
| ship_date | String | Yes | Ship date (e.g. "2026-02-17") |

### Example

```ruby
params = {
  carrier_id: 'se-carrier-1',
  warehouse_id: 'wh-1',
  ship_date: '2026-02-17'
}
response = client.manifests.create(params)
```

### Response

```json
{
  "manifest_id": "man-2"
}
```

---

## get_by_id

Retrieve a manifest by its ShipEngine manifest ID. Returns manifest details including form_data, carrier_id, and label_ids.

**Method:** `client.manifests.get_by_id(manifest_id, config: {})`

**API Endpoint:** `GET /v1/manifests/:manifest_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| manifest_id | String | Yes | The unique identifier of the manifest |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.manifests.get_by_id('man-1')
```

### Response

```json
{
  "manifest_id": "man-1"
}
```

---

## get_request_by_id

Retrieve a manifest request by its request ID. Used for async manifest creation—returns status and resulting manifest_id when complete.

**Method:** `client.manifests.get_request_by_id(request_id, config: {})`

**API Endpoint:** `GET /v1/manifests/requests/:request_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| request_id | String | Yes | The unique identifier of the manifest request |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.manifests.get_request_by_id('req-1')
```

### Response

```json
{
  "manifest_request_id": "req-1",
  "status": "completed"
}
```
