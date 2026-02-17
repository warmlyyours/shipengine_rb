# Tags

Manage tags for organizing and filtering shipments and other resources.

## list

Lists all tags in the account.

**Method:** `client.tags.list(config: {})`

**API Endpoint:** `GET /v1/tags`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.tags.list
```

### Response

```json
{
  "tags": [
    { "name": "priority" },
    { "name": "fragile" }
  ]
}
```

## create

Creates a new tag.

**Method:** `client.tags.create(tag_name, config: {})`

**API Endpoint:** `POST /v1/tags/{tag_name}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| tag_name | String | Yes | The name of the tag to create |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.tags.create('priority')
```

### Response

```json
{
  "name": "priority"
}
```

## delete

Deletes a tag.

**Method:** `client.tags.delete(tag_name, config: {})`

**API Endpoint:** `DELETE /v1/tags/{tag_name}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| tag_name | String | Yes | The name of the tag to delete |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.tags.delete('priority')
```

### Response

Returns HTTP 204 No Content with an empty body.

## rename

Renames a tag.

**Method:** `client.tags.rename(tag_name, new_tag_name, config: {})`

**API Endpoint:** `PUT /v1/tags/{tag_name}/{new_tag_name}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| tag_name | String | Yes | The current name of the tag |
| new_tag_name | String | Yes | The new name for the tag |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.tags.rename('priority', 'urgent')
```

### Response

```json
{}
```
