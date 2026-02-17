# Account

Manage ShipEngine account settings and branding images for labels.

## get_settings

Retrieves the current account settings.

**Method:** `client.account.get_settings(config: {})`

**API Endpoint:** `GET /v1/account/settings`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.account.get_settings
puts response['account_id']
```

### Response

```json
{
  "account_id": "acc-123"
}
```

## update_settings

Updates the account settings with the provided values.

**Method:** `client.account.update_settings(params, config: {})`

**API Endpoint:** `PUT /v1/account/settings`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Account settings to update (e.g., default_label_layout, units) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.account.update_settings({ default_label_layout: '4x6' })
```

### Response

```json
{}
```

## list_images

Lists all images configured for the account (e.g., logo for labels).

**Method:** `client.account.list_images(config: {})`

**API Endpoint:** `GET /v1/account/settings/images`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.account.list_images
response['images'].each { |img| puts img['image_id'] }
```

### Response

```json
{
  "images": [
    {
      "image_id": "img-1"
    }
  ]
}
```

## get_image

Retrieves a single image by ID.

**Method:** `client.account.get_image(image_id, config: {})`

**API Endpoint:** `GET /v1/account/settings/images/{image_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| image_id | String | Yes | The unique identifier of the image |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.account.get_image('img-1')
puts response['label_image_url']
```

### Response

```json
{
  "image_id": "img-1",
  "label_image_url": "https://..."
}
```

## create_image

Creates a new image for use on labels (e.g., logo).

**Method:** `client.account.create_image(params, config: {})`

**API Endpoint:** `POST /v1/account/settings/images`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Image details (e.g., label_image_url) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.account.create_image({ label_image_url: 'https://example.com/logo.png' })
puts response['image_id']
```

### Response

```json
{
  "image_id": "img-2"
}
```

## update_image

Updates an existing image.

**Method:** `client.account.update_image(image_id, params, config: {})`

**API Endpoint:** `PUT /v1/account/settings/images/{image_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| image_id | String | Yes | The unique identifier of the image to update |
| params | Hash | Yes | Updated image details (e.g., label_image_url) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.account.update_image('img-1', { label_image_url: 'https://example.com/new-logo.png' })
```

### Response

```json
{}
```

## delete_image

Deletes an image from the account.

**Method:** `client.account.delete_image(image_id, config: {})`

**API Endpoint:** `DELETE /v1/account/settings/images/{image_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| image_id | String | Yes | The unique identifier of the image to delete |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.account.delete_image('img-1')
```

### Response

```json
{}
```
