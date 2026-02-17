# Package Types

Manage package types. List all package types (carrier-defined and custom), create custom package types, and retrieve, update, or delete custom package types. API path: `/v1/packages`.

## list

List all package types (both carrier-defined and custom).

**Method:** `client.package_types.list(config: {})`

**API Endpoint:** `GET /v1/packages`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.package_types.list
```

### Response

```json
{
  "packages": [
    {
      "package_id": "pkg-1",
      "package_code": "custom_box",
      "name": "Custom Box"
    }
  ]
}
```

---

## create

Create a new custom package type. Provide name, dimensions, and optional weight.

**Method:** `client.package_types.create(params, config: {})`

**API Endpoint:** `POST /v1/packages`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Package type details |
| config | Hash | No | Per-request config overrides |

### params structure

| Name | Type | Required | Description |
|------|------|----------|-------------|
| package_code | String | Yes | Unique code for the package type |
| name | String | Yes | Display name |
| dimensions | Hash | Yes | Dimensions with `unit`, `length`, `width`, `height` |

### Example

```ruby
params = {
  package_code: 'my_box',
  name: 'My Box',
  dimensions: {
    unit: 'inch',
    length: 10,
    width: 8,
    height: 6
  }
}
response = client.package_types.create(params)
```

### Response

```json
{
  "package_id": "pkg-2",
  "package_code": "my_box"
}
```

---

## get_by_id

Retrieve a package type by its ID.

**Method:** `client.package_types.get_by_id(package_id, config: {})`

**API Endpoint:** `GET /v1/packages/:package_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| package_id | String | Yes | The unique identifier of the package type |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.package_types.get_by_id('pkg-1')
```

### Response

```json
{
  "package_id": "pkg-1",
  "name": "Custom Box"
}
```

---

## update

Update an existing custom package type. Modify name, dimensions, or other details.

**Method:** `client.package_types.update(package_id, params, config: {})`

**API Endpoint:** `PUT /v1/packages/:package_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| package_id | String | Yes | The unique identifier of the package type to update |
| params | Hash | Yes | Updated package type details |
| config | Hash | No | Per-request config overrides |

### params structure

| Name | Type | Required | Description |
|------|------|----------|-------------|
| name | String | No | Updated display name |
| dimensions | Hash | No | Updated dimensions |

### Example

```ruby
params = { name: 'Updated Box' }
response = client.package_types.update('pkg-1', params)
```

### Response

Returns the updated package type. When the API returns an empty body, the response may be empty:

```json
{}
```

---

## delete

Delete a custom package type.

**Method:** `client.package_types.delete(package_id, config: {})`

**API Endpoint:** `DELETE /v1/packages/:package_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| package_id | String | Yes | The unique identifier of the package type to delete |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.package_types.delete('pkg-1')
```

### Response

Returns HTTP 204 No Content with an empty body.
