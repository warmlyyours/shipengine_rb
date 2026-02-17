# Package Pickups

Manage carrier package pickups. List pickups, schedule pickups for labels, retrieve pickup details, and cancel scheduled pickups. API path: `/v1/pickups`.

## list

List package pickups with optional filtering via query parameters.

**Method:** `client.package_pickups.list(params = {}, config: {})`

**API Endpoint:** `GET /v1/pickups`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | No | Query parameters for filtering pickups (e.g. page, page_size, status) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.package_pickups.list
# or with pagination:
response = client.package_pickups.list(page: 1, page_size: 25)
```

### Response

```json
{
  "pickups": [
    {
      "pickup_id": "se-pickup-123",
      "carrier_id": "se-28529731",
      "status": "scheduled",
      "pickup_date": "2026-02-20",
      "label_ids": ["se-label-456", "se-label-789"],
      "created_at": "2026-02-17T10:00:00.000Z"
    }
  ],
  "total": 1,
  "page": 1,
  "pages": 1
}
```

---

## schedule

Schedule a carrier pickup for packages. Provide carrier ID and label IDs to include in the pickup.

**Method:** `client.package_pickups.schedule(params, config: {})`

**API Endpoint:** `POST /v1/pickups`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Pickup scheduling details |
| config | Hash | No | Per-request config overrides |

### params structure

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_id | String | Yes | The carrier ID |
| label_ids | Array<String> | Yes | Array of label IDs to include in the pickup |

### Example

```ruby
response = client.package_pickups.schedule(
  carrier_id: 'se-123',
  label_ids: ['se-label-456']
)
```

### Response

```json
{
  "pickup_id": "se-pickup-123",
  "carrier_id": "se-123",
  "status": "scheduled",
  "pickup_date": "2026-02-20",
  "label_ids": ["se-label-456"],
  "created_at": "2026-02-17T10:00:00.000Z"
}
```

---

## get_by_id

Retrieve a single pickup by its ID.

**Method:** `client.package_pickups.get_by_id(pickup_id, config: {})`

**API Endpoint:** `GET /v1/pickups/:pickup_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| pickup_id | String | Yes | The unique identifier of the pickup |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.package_pickups.get_by_id('se-pickup-123')
```

### Response

```json
{
  "pickup_id": "se-pickup-123",
  "carrier_id": "se-123",
  "status": "scheduled",
  "pickup_date": "2026-02-20",
  "label_ids": ["se-label-456"],
  "created_at": "2026-02-17T10:00:00.000Z",
  "modified_at": "2026-02-17T10:00:00.000Z"
}
```

---

## delete

Cancel or delete a scheduled pickup.

**Method:** `client.package_pickups.delete(pickup_id, config: {})`

**API Endpoint:** `DELETE /v1/pickups/:pickup_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| pickup_id | String | Yes | The unique identifier of the pickup to delete |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.package_pickups.delete('se-pickup-123')
```

### Response

Returns HTTP 204 No Content with an empty body, or a confirmation object when the API returns one.
