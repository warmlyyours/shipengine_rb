# Webhooks

List, create, retrieve, update, and delete webhook subscriptions for event notifications.

## list

Lists all webhooks in the account.

**Method:** `client.webhooks.list(config: {})`

**API Endpoint:** `GET /v1/environment/webhooks`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.webhooks.list
```

### Response

```json
[
  {
    "webhook_id": "wh-1",
    "url": "https://example.com/hook",
    "event": "track"
  }
]
```

## create

Creates a new webhook subscription.

**Method:** `client.webhooks.create(params, config: {})`

**API Endpoint:** `POST /v1/environment/webhooks`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Webhook details (url, event, etc.) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.webhooks.create({
  url: 'https://example.com/hook',
  event: 'track'
})
```

### Response

```json
{
  "webhook_id": "wh-2",
  "url": "https://example.com/hook"
}
```

## get_by_id

Retrieves a webhook by its ID.

**Method:** `client.webhooks.get_by_id(webhook_id, config: {})`

**API Endpoint:** `GET /v1/environment/webhooks/{webhook_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| webhook_id | String | Yes | The unique identifier of the webhook |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.webhooks.get_by_id('wh-1')
```

### Response

```json
{
  "webhook_id": "wh-1",
  "url": "https://example.com/hook"
}
```

## update

Updates an existing webhook.

**Method:** `client.webhooks.update(webhook_id, params, config: {})`

**API Endpoint:** `PUT /v1/environment/webhooks/{webhook_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| webhook_id | String | Yes | The unique identifier of the webhook to update |
| params | Hash | Yes | Updated webhook details |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.webhooks.update('wh-1', { url: 'https://example.com/new-hook' })
```

### Response

```json
{}
```

## delete

Deletes a webhook subscription.

**Method:** `client.webhooks.delete(webhook_id, config: {})`

**API Endpoint:** `DELETE /v1/environment/webhooks/{webhook_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| webhook_id | String | Yes | The unique identifier of the webhook to delete |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.webhooks.delete('wh-1')
```

### Response

Returns HTTP 204 No Content with an empty body.
