# Labels

Create, void, list, and retrieve shipping labels.

## create_from_rate

Creates a shipping label from a previously retrieved rate.

**Method:** `client.labels.create_from_rate(rate_id, params = {}, config: {})`

**API Endpoint:** `POST /v1/labels/rates/{rate_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| rate_id | String | Yes | The rate ID from a rates lookup (e.g. "se-324658") |
| params | Hash | No | Optional label parameters (e.g. label_layout, label_format, label_download_type) |
| config | Hash | No | Per-request config overrides (e.g. idempotency_key) |

### Example

```ruby
response = client.labels.create_from_rate('se-324658', {})
```

### Response

```json
{
  "label_id": "se-28529731",
  "status": "processing",
  "shipment_id": "se-28529731",
  "ship_date": "2018-09-23T00:00:00.000Z",
  "created_at": "2018-09-23T15:00:00.000Z",
  "shipment_cost": {
    "currency": "usd",
    "amount": 0
  },
  "insurance_cost": {
    "currency": "usd",
    "amount": 0
  },
  "tracking_number": "782758401696",
  "is_return_label": true,
  "rma_number": "string",
  "is_international": true,
  "batch_id": "se-28529731",
  "carrier_id": "se-28529731",
  "charge_event": "carrier_default",
  "service_code": "usps_first_class_mail",
  "package_code": "small_flat_rate_box",
  "voided": true,
  "voided_at": "2018-09-23T15:00:00.000Z",
  "label_format": "pdf",
  "display_scheme": "label",
  "label_layout": "4x6",
  "trackable": true,
  "label_image_id": "img_DtBXupDBxREpHnwEXhTfgK",
  "carrier_code": "dhl_express",
  "tracking_status": "unknown",
  "label_download": {
    "href": "http://api.shipengine.com/v1/labels/se-28529731",
    "pdf": "http://api.shipengine.com/v1/labels/se-28529731",
    "png": "http://api.shipengine.com/v1/labels/se-28529731",
    "zpl": "http://api.shipengine.com/v1/labels/se-28529731"
  },
  "form_download": {
    "href": "http://api.shipengine.com/v1/labels/se-28529731",
    "type": "string"
  },
  "insurance_claim": {
    "href": "http://api.shipengine.com/v1/labels/se-28529731",
    "type": "string"
  },
  "packages": [
    {
      "package_code": "small_flat_rate_box",
      "weight": {
        "value": 0,
        "unit": "pound"
      },
      "dimensions": {
        "unit": "inch",
        "length": 0,
        "width": 0,
        "height": 0
      },
      "insured_value": {
        "currency": "usd",
        "amount": 0
      },
      "tracking_number": "1Z932R800392060079",
      "label_messages": {
        "reference1": null,
        "reference2": null,
        "reference3": null
      },
      "external_package_id": "string"
    }
  ]
}
```

## create_from_shipment_details

Creates a shipping label from full shipment details (carrier, service, addresses, packages, etc.).

**Method:** `client.labels.create_from_shipment_details(params, config: {})`

**API Endpoint:** `POST /v1/labels`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Shipment details (carrier_id, service_code, ship_to, ship_from, packages, etc.) |
| config | Hash | No | Per-request config overrides (e.g. idempotency_key) |

### Example

```ruby
response = client.labels.create_from_shipment_details({})
```

### Response

```json
{
  "label_id": "se-28529731",
  "status": "processing",
  "shipment_id": "se-28529731",
  "ship_date": "2018-09-23T00:00:00.000Z",
  "created_at": "2018-09-23T15:00:00.000Z",
  "shipment_cost": {
    "currency": "usd",
    "amount": 0
  },
  "insurance_cost": {
    "currency": "usd",
    "amount": 0
  },
  "tracking_number": "782758401696",
  "is_return_label": true,
  "rma_number": "string",
  "is_international": true,
  "batch_id": "se-28529731",
  "carrier_id": "se-28529731",
  "charge_event": "carrier_default",
  "service_code": "usps_first_class_mail",
  "package_code": "small_flat_rate_box",
  "voided": true,
  "voided_at": "2018-09-23T15:00:00.000Z",
  "label_format": "pdf",
  "display_scheme": "label",
  "label_layout": "4x6",
  "trackable": true,
  "label_image_id": "img_DtBXupDBxREpHnwEXhTfgK",
  "carrier_code": "dhl_express",
  "tracking_status": "unknown",
  "label_download": {
    "href": "http://api.shipengine.com/v1/labels/se-28529731",
    "pdf": "http://api.shipengine.com/v1/labels/se-28529731",
    "png": "http://api.shipengine.com/v1/labels/se-28529731",
    "zpl": "http://api.shipengine.com/v1/labels/se-28529731"
  },
  "form_download": {
    "href": "http://api.shipengine.com/v1/labels/se-28529731",
    "type": "string"
  },
  "insurance_claim": {
    "href": "http://api.shipengine.com/v1/labels/se-28529731",
    "type": "string"
  },
  "packages": [
    {
      "package_code": "small_flat_rate_box",
      "weight": {
        "value": 0,
        "unit": "pound"
      },
      "dimensions": {
        "unit": "inch",
        "length": 0,
        "width": 0,
        "height": 0
      },
      "insured_value": {
        "currency": "usd",
        "amount": 0
      },
      "tracking_number": "1Z932R800392060079",
      "label_messages": {
        "reference1": null,
        "reference2": null,
        "reference3": null
      },
      "external_package_id": "string"
    }
  ]
}
```

## void

Voids a label. Once voided, the label cannot be used for shipping.

**Method:** `client.labels.void(label_id, config: {})`

**API Endpoint:** `PUT /v1/labels/{label_id}/void`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| label_id | String | Yes | The ShipEngine label ID (e.g. "se-28529731") |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.labels.void('se-28529731')
```

### Response

```json
{
  "approved": true,
  "message": "Request for refund submitted.  This label has been voided."
}
```

## list

Lists labels with optional filtering and pagination.

**Method:** `client.labels.list(params = {}, config: {})`

**API Endpoint:** `GET /v1/labels`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | No | Query params (e.g. page, page_size, label_status, etc.) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.labels.list
```

### Response

```json
{
  "labels": [
    {
      "label_id": "se-label-1",
      "status": "completed"
    }
  ],
  "total": 1,
  "page": 1,
  "pages": 1
}
```

## get_by_id

Retrieves a single label by its ShipEngine label ID.

**Method:** `client.labels.get_by_id(label_id, config: {})`

**API Endpoint:** `GET /v1/labels/{label_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| label_id | String | Yes | The ShipEngine label ID (e.g. "se-label-1") |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.labels.get_by_id('se-label-1')
```

### Response

```json
{
  "label_id": "se-label-1",
  "status": "completed"
}
```

## get_by_external_shipment_id

Retrieves a label by its external shipment ID (your application's reference).

**Method:** `client.labels.get_by_external_shipment_id(external_shipment_id, config: {})`

**API Endpoint:** `GET /v1/labels/external_shipment_id/{external_shipment_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| external_shipment_id | String | Yes | Your application's external shipment ID (e.g. "ext-ship-1") |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.labels.get_by_external_shipment_id('ext-ship-1')
```

### Response

```json
{
  "label_id": "se-label-1"
}
```

## create_return_label

Creates a return label for an existing outbound label.

**Method:** `client.labels.create_return_label(label_id, params = {}, config: {})`

**API Endpoint:** `POST /v1/labels/{label_id}/return`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| label_id | String | Yes | The ShipEngine label ID of the original outbound label (e.g. "se-label-1") |
| params | Hash | No | Return label options (e.g. label_format, label_layout) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
params = { label_format: 'pdf', label_layout: '4x6' }
response = client.labels.create_return_label('se-label-1', params)
```

### Response

```json
{
  "label_id": "se-return-1",
  "is_return_label": true
}
```

## create_from_shipment_id

Creates a shipping label from an existing shipment.

**Method:** `client.labels.create_from_shipment_id(shipment_id, params = {}, config: {})`

**API Endpoint:** `POST /v1/labels/shipment/{shipment_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| shipment_id | String | Yes | The ShipEngine shipment ID (e.g. "se-ship-1") |
| params | Hash | No | Optional label parameters (e.g. label_format, label_layout) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
params = { label_format: 'pdf' }
response = client.labels.create_from_shipment_id('se-ship-1', params)
```

### Response

```json
{
  "label_id": "se-label-new",
  "shipment_id": "se-ship-1"
}
```
