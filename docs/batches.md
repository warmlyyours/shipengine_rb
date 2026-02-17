# Batches

Manage label batches. Batches allow you to create multiple labels at once and process them together.

## list

Lists all batches, optionally filtered by status and paginated.

**Method:** `client.batches.list(params = {}, config: {})`

**API Endpoint:** `GET /v1/batches`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | No | Query params (page, page_size, status, etc.) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.batches.list
puts response['total']
response['batches'].each { |b| puts b['batch_id'] }
```

### Response

```json
{
  "batches": [
    {
      "batch_id": "se-batch-1",
      "status": "open"
    }
  ],
  "total": 1,
  "page": 1,
  "pages": 1
}
```

## create

Creates a new batch with the specified shipments.

**Method:** `client.batches.create(params, config: {})`

**API Endpoint:** `POST /v1/batches`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Batch details (shipment_ids, rate_ids, etc.) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.batches.create({ shipment_ids: ['se-12345'] })
puts response['batch_id']
```

### Response

```json
{
  "batch_id": "se-batch-2",
  "status": "open"
}
```

## get_by_id

Retrieves a batch by its ShipEngine batch ID.

**Method:** `client.batches.get_by_id(batch_id, config: {})`

**API Endpoint:** `GET /v1/batches/{batch_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| batch_id | String | Yes | The unique identifier of the batch |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.batches.get_by_id('se-batch-1')
puts response['batch_id']
puts response['status']
```

### Response

```json
{
  "batch_id": "se-batch-1",
  "status": "open"
}
```

## delete

Deletes a batch. Only batches that have not been processed can be deleted.

**Method:** `client.batches.delete(batch_id, config: {})`

**API Endpoint:** `DELETE /v1/batches/{batch_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| batch_id | String | Yes | The unique identifier of the batch to delete |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.batches.delete('se-batch-1')
```

### Response

```json
{}
```

## process

Processes a batch to generate labels for all shipments.

**Method:** `client.batches.process(batch_id, params = {}, config: {})`

**API Endpoint:** `POST /v1/batches/{batch_id}/process/labels`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| batch_id | String | Yes | The unique identifier of the batch to process |
| params | Hash | No | Processing options (e.g., label_layout, label_format) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.batches.process('se-batch-1')
```

### Response

```json
{}
```

## get_by_external_id

Retrieves a batch by its external batch ID (your system's reference).

**Method:** `client.batches.get_by_external_id(external_batch_id, config: {})`

**API Endpoint:** `GET /v1/batches/external_batch_id/{external_batch_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| external_batch_id | String | Yes | Your external reference for the batch |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.batches.get_by_external_id('ext-batch-1')
puts response['batch_id']
puts response['external_batch_id']
```

### Response

```json
{
  "batch_id": "se-batch-1",
  "external_batch_id": "ext-batch-1"
}
```

## add_shipments

Adds shipments to an existing batch.

**Method:** `client.batches.add_shipments(batch_id, params, config: {})`

**API Endpoint:** `POST /v1/batches/{batch_id}/add`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| batch_id | String | Yes | The unique identifier of the batch |
| params | Hash | Yes | shipment_ids array of shipment IDs to add |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.batches.add_shipments('se-batch-1', { shipment_ids: ['se-ship-1', 'se-ship-2'] })
```

### Response

```json
{}
```

## remove_shipments

Removes shipments from an existing batch.

**Method:** `client.batches.remove_shipments(batch_id, params, config: {})`

**API Endpoint:** `POST /v1/batches/{batch_id}/remove`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| batch_id | String | Yes | The unique identifier of the batch |
| params | Hash | Yes | shipment_ids array of shipment IDs to remove |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.batches.remove_shipments('se-batch-1', { shipment_ids: ['se-ship-1'] })
```

### Response

```json
{}
```

## get_errors

Retrieves errors for a batch (e.g., validation or processing failures).

**Method:** `client.batches.get_errors(batch_id, config: {})`

**API Endpoint:** `GET /v1/batches/{batch_id}/errors`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| batch_id | String | Yes | The unique identifier of the batch |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.batches.get_errors('se-batch-1')
response['errors'].each { |e| puts e['error'] }
```

### Response

```json
{
  "errors": [
    {
      "error": "Invalid address"
    }
  ]
}
```
