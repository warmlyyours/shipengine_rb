# Tracking

Track packages by label ID or carrier/tracking number, and start or stop tracking webhooks for a package.

## track_by_label_id

Gets tracking information for a package by its ShipEngine label ID.

**Method:** `client.tracking.track_by_label_id(label_id, config: {})`

**API Endpoint:** `GET /v1/labels/{label_id}/track`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| label_id | String | Yes | The ShipEngine label ID (e.g. "se-324658") |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.tracking.track_by_label_id('se-324658')
```

### Response

```json
{
  "tracking_number": "1Z932R800390810600",
  "status_code": "DE",
  "status_description": "Delivered",
  "carrier_status_code": "D",
  "carrier_status_description": "DELIVERED",
  "shipped_date": "2019-07-27T11:59:03.289Z",
  "estimated_delivery_date": "2019-07-27T11:59:03.289Z",
  "actual_delivery_date": "2019-07-27T11:59:03.289Z",
  "exception_description": null,
  "events": [
    {
      "occurred_at": "2019-09-13T12:32:00Z",
      "carrier_occurred_at": "2019-09-13T05:32:00",
      "description": "Arrived at USPS Facility",
      "city_locality": "OCEANSIDE",
      "state_province": "CA",
      "postal_code": "92056",
      "country_code": "",
      "company_name": "",
      "signer": "",
      "event_code": "U1",
      "latitude": -90,
      "longitude": -180
    }
  ]
}
```

## track

Gets tracking information for a package by carrier code and tracking number.

**Method:** `client.tracking.track(carrier_code, tracking_number, config: {})`

**API Endpoint:** `GET /v1/tracking?carrier_code={carrier_code}&tracking_number={tracking_number}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_code | String | Yes | Carrier code (e.g. "stamps_com", "ups", "fedex") |
| tracking_number | String | Yes | The carrier's tracking number |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.tracking.track('1', '1')
```

### Response

```json
{
  "tracking_number": "1Z932R800390810600",
  "status_code": "DE",
  "status_description": "Delivered",
  "carrier_status_code": "D",
  "carrier_status_description": "DELIVERED",
  "shipped_date": "2019-07-27T11:59:03.289Z",
  "estimated_delivery_date": "2019-07-27T11:59:03.289Z",
  "actual_delivery_date": "2019-07-27T11:59:03.289Z",
  "exception_description": null,
  "events": [
    {
      "occurred_at": "2019-09-13T12:32:00Z",
      "carrier_occurred_at": "2019-09-13T05:32:00",
      "description": "Arrived at USPS Facility",
      "city_locality": "OCEANSIDE",
      "state_province": "CA",
      "postal_code": "92056",
      "country_code": "",
      "company_name": "",
      "signer": "",
      "event_code": "U1",
      "latitude": -90,
      "longitude": -180
    }
  ]
}
```

## start

Starts real-time tracking updates (webhooks) for a package. ShipEngine will send tracking events to your webhook URL as they occur.

**Method:** `client.tracking.start(carrier_code, tracking_number, config: {})`

**API Endpoint:** `POST /v1/tracking/start`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_code | String | Yes | Carrier code (e.g. "stamps_com", "ups", "fedex") |
| tracking_number | String | Yes | The carrier's tracking number |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.tracking.start('stamps_com', '9400111899223456')
```

### Response

Returns HTTP 204 No Content with an empty body. The request succeeds if no exception is raised.

```json
{}
```

## stop

Stops real-time tracking updates (webhooks) for a package.

**Method:** `client.tracking.stop(carrier_code, tracking_number, config: {})`

**API Endpoint:** `POST /v1/tracking/stop`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_code | String | Yes | Carrier code (e.g. "stamps_com", "ups", "fedex") |
| tracking_number | String | Yes | The carrier's tracking number |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.tracking.stop('stamps_com', '9400111899223456')
```

### Response

Returns HTTP 204 No Content with an empty body. The request succeeds if no exception is raised.

```json
{}
```
