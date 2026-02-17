# Shipments

Create, list, update, cancel shipments, manage tags, parse addresses from text, and get shipping rates.

## list

Lists shipments with optional filtering via query parameters.

**Method:** `client.shipments.list(params = {}, config: {})`

**API Endpoint:** `GET /v1/shipments`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | No | Query params (page, page_size, shipment_status, etc.) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.shipments.list(page: 1, page_size: 25, shipment_status: 'label_purchased')
```

### Response

```json
{
  "shipments": [
    {
      "shipment_id": "se-12345",
      "shipment_status": "pending"
    }
  ],
  "total": 1,
  "page": 1,
  "pages": 1
}
```

## create

Creates a new shipment.

**Method:** `client.shipments.create(params, config: {})`

**API Endpoint:** `POST /v1/shipments`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Shipment details (shipments array with service_code, ship_to, ship_from, packages, etc.) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.shipments.create({
  shipments: [{
    service_code: 'usps_priority_mail',
    ship_to: {},
    ship_from: {},
    packages: []
  }]
})
```

### Response

```json
{
  "has_errors": false,
  "shipments": [
    {
      "shipment_id": "se-99999",
      "shipment_status": "pending"
    }
  ]
}
```

## get_by_id

Retrieves a shipment by its ID.

**Method:** `client.shipments.get_by_id(shipment_id, config: {})`

**API Endpoint:** `GET /v1/shipments/{shipment_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| shipment_id | String | Yes | The unique identifier of the shipment |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.shipments.get_by_id('se-12345')
```

### Response

```json
{
  "shipment_id": "se-12345",
  "shipment_status": "pending"
}
```

## update

Updates an existing shipment.

**Method:** `client.shipments.update(shipment_id, params, config: {})`

**API Endpoint:** `PUT /v1/shipments/{shipment_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| shipment_id | String | Yes | The unique identifier of the shipment to update |
| params | Hash | Yes | Updated shipment details |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.shipments.update('se-12345', { service_code: 'usps_first_class_mail' })
```

### Response

```json
{
  "shipment_id": "se-12345",
  "shipment_status": "pending"
}
```

## cancel

Cancels a shipment.

**Method:** `client.shipments.cancel(shipment_id, config: {})`

**API Endpoint:** `PUT /v1/shipments/{shipment_id}/cancel`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| shipment_id | String | Yes | The unique identifier of the shipment to cancel |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.shipments.cancel('se-12345')
```

### Response

```json
{}
```

## add_tag

Adds a tag to a shipment.

**Method:** `client.shipments.add_tag(shipment_id, tag_name, config: {})`

**API Endpoint:** `POST /v1/shipments/{shipment_id}/tags/{tag_name}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| shipment_id | String | Yes | The unique identifier of the shipment |
| tag_name | String | Yes | The name of the tag to add |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.shipments.add_tag('se-12345', 'priority')
```

### Response

```json
{
  "shipment_id": "se-12345",
  "tag_name": "priority"
}
```

## remove_tag

Removes a tag from a shipment.

**Method:** `client.shipments.remove_tag(shipment_id, tag_name, config: {})`

**API Endpoint:** `DELETE /v1/shipments/{shipment_id}/tags/{tag_name}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| shipment_id | String | Yes | The unique identifier of the shipment |
| tag_name | String | Yes | The name of the tag to remove |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.shipments.remove_tag('se-12345', 'priority')
```

### Response

```json
{}
```

## get_by_external_id

Retrieves a shipment by its external ID (your system's reference).

**Method:** `client.shipments.get_by_external_id(external_shipment_id, config: {})`

**API Endpoint:** `GET /v1/shipments/external_shipment_id/{external_shipment_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| external_shipment_id | String | Yes | Your external reference for the shipment |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.shipments.get_by_external_id('ext-ship-1')
```

### Response

```json
{
  "shipment_id": "se-12345",
  "external_shipment_id": "ext-ship-1"
}
```

## parse

Parses unstructured address text into structured address components.

**Method:** `client.shipments.parse(params, config: {})`

**API Endpoint:** `PUT /v1/shipments/recognize`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Text and address data to parse (must include `text` key) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.shipments.parse({
  text: 'Ship to John Smith at 123 Main St, Austin TX 78701'
})
```

### Response

```json
{
  "score": 0.9,
  "shipment": {
    "ship_to": {
      "name": "John Smith"
    }
  }
}
```

## get_rates

Gets available shipping rates for a shipment.

**Method:** `client.shipments.get_rates(shipment_id, params = {}, config: {})`

**API Endpoint:** `GET /v1/shipments/{shipment_id}/rates`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| shipment_id | String | Yes | The unique identifier of the shipment |
| params | Hash | No | Query params (e.g. created_at_start) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.shipments.get_rates('se-12345')
```

### Response

```json
{
  "rates": [
    {
      "rate_id": "rate-1",
      "shipping_amount": {
        "amount": 5.99
      }
    }
  ]
}
```

## list_tags

Lists all tags associated with a shipment.

**Method:** `client.shipments.list_tags(shipment_id, config: {})`

**API Endpoint:** `GET /v1/shipments/{shipment_id}/tags`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| shipment_id | String | Yes | The unique identifier of the shipment |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.shipments.list_tags('se-12345')
```

### Response

```json
{
  "tags": [
    {
      "name": "priority"
    }
  ]
}
```

## update_tags

Bulk updates tags across multiple shipments.

**Method:** `client.shipments.update_tags(params, config: {})`

**API Endpoint:** `PUT /v1/shipments/tags`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Bulk tag update body (shipment_ids, tags to add/remove) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.shipments.update_tags({
  shipment_ids: ['se-12345'],
  tags: [{ name: 'priority' }]
})
```

### Response

Returns HTTP 204 No Content with an empty body.
