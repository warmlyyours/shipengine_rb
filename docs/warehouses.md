# Warehouses

List, create, retrieve, update, delete warehouses, and update warehouse settings.

## list

Lists all warehouses in the account.

**Method:** `client.warehouses.list(config: {})`

**API Endpoint:** `GET /v1/warehouses`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.warehouses.list
```

### Response

```json
{
  "warehouses": [
    {
      "warehouse_id": "wh-123",
      "name": "Main Warehouse"
    }
  ]
}
```

## create

Creates a new warehouse.

**Method:** `client.warehouses.create(params, config: {})`

**API Endpoint:** `POST /v1/warehouses`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Warehouse details (name, origin_address, etc.) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.warehouses.create({
  name: 'New Warehouse',
  origin_address: { address_line1: '123 Main St' }
})
```

### Response

```json
{
  "warehouse_id": "wh-456",
  "name": "New Warehouse"
}
```

## get_by_id

Retrieves a warehouse by its ID.

**Method:** `client.warehouses.get_by_id(warehouse_id, config: {})`

**API Endpoint:** `GET /v1/warehouses/{warehouse_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| warehouse_id | String | Yes | The unique identifier of the warehouse |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.warehouses.get_by_id('wh-123')
```

### Response

```json
{
  "warehouse_id": "wh-123",
  "name": "Main Warehouse"
}
```

## update

Updates an existing warehouse.

**Method:** `client.warehouses.update(warehouse_id, params, config: {})`

**API Endpoint:** `PUT /v1/warehouses/{warehouse_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| warehouse_id | String | Yes | The unique identifier of the warehouse to update |
| params | Hash | Yes | Updated warehouse details |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.warehouses.update('wh-123', { name: 'Updated Warehouse' })
```

### Response

```json
{}
```

## delete

Deletes a warehouse.

**Method:** `client.warehouses.delete(warehouse_id, config: {})`

**API Endpoint:** `DELETE /v1/warehouses/{warehouse_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| warehouse_id | String | Yes | The unique identifier of the warehouse to delete |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.warehouses.delete('wh-123')
```

### Response

Returns HTTP 204 No Content with an empty body.

## update_settings

Updates settings for a warehouse.

**Method:** `client.warehouses.update_settings(warehouse_id, params, config: {})`

**API Endpoint:** `PUT /v1/warehouses/{warehouse_id}/settings`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| warehouse_id | String | Yes | The unique identifier of the warehouse |
| params | Hash | Yes | Warehouse settings to update |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.warehouses.update_settings('wh-123', { is_default: true })
```

### Response

Returns HTTP 204 No Content with an empty body.
