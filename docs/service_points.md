# Service Points

Carrier service points (e.g., pickup/dropoff locations). List service points by location and carrier, and retrieve a single service point by ID. API path: `/v1/service_points`.

## list

List service points matching the given criteria. Provide address query and carrier providers. Uses POST with a request body.

**Method:** `client.service_points.list(params = {}, config: {})`

**API Endpoint:** `POST /v1/service_points/list`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Query params including address_query and providers |
| config | Hash | No | Per-request config overrides |

### params structure

| Name | Type | Required | Description |
|------|------|----------|-------------|
| address_query | Hash | Yes | Location criteria (postal_code, country_code) |
| address_query.postal_code | String | Yes | Postal/zip code |
| address_query.country_code | String | Yes | ISO 3166-1 alpha-2 country code (e.g. "US") |
| providers | Array | Yes | Array of provider objects with carrier_id |

### Example

```ruby
params = {
  address_query: {
    postal_code: '78756',
    country_code: 'US'
  },
  providers: [
    { carrier_id: 'se-1' }
  ]
}
response = client.service_points.list(params)
```

### Response

```json
{
  "service_points": [
    {
      "service_point_id": "sp-1",
      "carrier_code": "ups"
    }
  ]
}
```

---

## get_by_id

Retrieve a single service point by carrier, country, and service point ID.

**Method:** `client.service_points.get_by_id(carrier_code, country_code, service_point_id, config: {})`

**API Endpoint:** `GET /v1/service_points/:carrier_code/:country_code/:service_point_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_code | String | Yes | The carrier code (e.g. "ups", "fedex") |
| country_code | String | Yes | The ISO 3166-1 alpha-2 country code |
| service_point_id | String | Yes | The unique identifier of the service point |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.service_points.get_by_id('ups', 'US', 'sp-1')
```

### Response

```json
{
  "service_point_id": "sp-1",
  "carrier_code": "ups"
}
```
