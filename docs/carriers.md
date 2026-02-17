# Carriers

Manage carrier accounts. List connected carriers, get carrier details, disconnect carriers, add funds, and list services, packages, and options per carrier.

## list

List all carriers connected to the account.

**Method:** `client.carriers.list(config: {})`

**API Endpoint:** `GET /v1/carriers`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.carriers.list
```

### Response

```json
{
  "carriers": [
    {
      "carrier_id": "se-28529731",
      "carrier_code": "se-28529731",
      "account_number": "account_570827",
      "requires_funded_amount": true,
      "balance": 3799.52,
      "nickname": "ShipEngine Account - Stamps.com",
      "friendly_name": "Stamps.com",
      "primary": true,
      "has_multi_package_supporting_services": true,
      "supports_label_messages": true,
      "services": [
        {
          "carrier_id": "se-28529731",
          "carrier_code": "se-28529731",
          "service_code": "usps_media_mail",
          "name": "USPS First Class Mail",
          "domestic": true,
          "international": true,
          "is_multi_package_supported": true
        }
      ],
      "packages": [
        {
          "package_id": "se-28529731",
          "package_code": "small_flat_rate_box",
          "name": "laptop_box",
          "dimensions": {
            "unit": "inch",
            "length": 1,
            "width": 1,
            "height": 1
          },
          "description": "Packaging for laptops"
        }
      ],
      "options": [
        {
          "name": "contains_alcohol",
          "default_value": "false",
          "description": "string"
        }
      ]
    },
    {
      "carrier_id": "se-test",
      "carrier_code": "se-testing",
      "account_number": "account_117",
      "requires_funded_amount": true,
      "balance": 3799.12,
      "nickname": "ShipEngine Account 2",
      "friendly_name": "Stamps.com 2",
      "primary": false,
      "has_multi_package_supporting_services": false,
      "supports_label_messages": false,
      "services": [
        {
          "carrier_id": "se-test",
          "carrier_code": "se-test",
          "service_code": "usps_media_mail+test",
          "name": "USPS First Class Mail test",
          "domestic": false,
          "international": false,
          "is_multi_package_supported": false
        }
      ],
      "packages": [
        {
          "package_id": "se-28529731",
          "package_code": "+small_flat_rate_box",
          "name": "laptop_box+test",
          "dimensions": {
            "unit": "centimeters",
            "length": 4,
            "width": 1,
            "height": 1
          },
          "description": "Packaging for laptops"
        }
      ],
      "options": [
        {
          "name": "contains_alcohol",
          "default_value": "false",
          "description": "string"
        }
      ]
    }
  ],
  "request_id": "aa3d8e8e-462b-4476-9618-72db7f7b7009",
  "errors": [
    {
      "error_source": "carrier",
      "error_type": "account_status",
      "error_code": "auto_fund_not_supported",
      "message": "Body of request cannot be null."
    }
  ]
}
```

## get_by_id

Retrieve a single carrier by ID.

**Method:** `client.carriers.get_by_id(carrier_id, config: {})`

**API Endpoint:** `GET /v1/carriers/:carrier_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_id | String | Yes | The carrier ID (e.g. "se-123") |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.carriers.get_by_id('se-123')
```

### Response

```json
{
  "carrier_id": "se-123",
  "carrier_code": "stamps_com"
}
```

## disconnect

Disconnect a carrier from the account.

**Method:** `client.carriers.disconnect(carrier_id, config: {})`

**API Endpoint:** `DELETE /v1/carriers/:carrier_id`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_id | String | Yes | The carrier ID to disconnect |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.carriers.disconnect('se-123')
```

### Response

Returns HTTP 204 No Content with an empty body.

## add_funds

Add funds to a carrier account.

**Method:** `client.carriers.add_funds(carrier_id, amount, config: {})`

**API Endpoint:** `PUT /v1/carriers/:carrier_id/add_funds`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_id | String | Yes | The carrier ID |
| amount | Hash | Yes | Object with `currency` and `amount` keys |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.carriers.add_funds('se-123', {
  currency: 'usd',
  amount: 25.00
})
```

### Response

```json
{
  "currency": "usd",
  "amount": 125.00
}
```

## list_services

List services available for a carrier.

**Method:** `client.carriers.list_services(carrier_id, config: {})`

**API Endpoint:** `GET /v1/carriers/:carrier_id/services`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_id | String | Yes | The carrier ID |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.carriers.list_services('se-123')
```

### Response

```json
{
  "services": [
    {
      "service_code": "usps_priority",
      "name": "USPS Priority"
    }
  ]
}
```

## list_packages

List packages available for a carrier.

**Method:** `client.carriers.list_packages(carrier_id, config: {})`

**API Endpoint:** `GET /v1/carriers/:carrier_id/packages`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_id | String | Yes | The carrier ID |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.carriers.list_packages('se-123')
```

### Response

```json
{
  "packages": [
    {
      "package_code": "flat_rate_box",
      "name": "Flat Rate Box"
    }
  ]
}
```

## list_options

List options available for a carrier.

**Method:** `client.carriers.list_options(carrier_id, config: {})`

**API Endpoint:** `GET /v1/carriers/:carrier_id/options`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_id | String | Yes | The carrier ID |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.carriers.list_options('se-123')
```

### Response

```json
{
  "options": [
    {
      "name": "contains_alcohol",
      "default_value": "false"
    }
  ]
}
```
