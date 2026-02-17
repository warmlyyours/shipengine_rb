# Carrier Accounts

Connect and manage carrier connections. Handles OAuth and credential-based connections to carriers like FedEx, UPS, Stamps.com.

## connect

Connects a carrier account to your ShipEngine account.

**Method:** `client.carrier_accounts.connect(carrier_name, params, config: {})`

**API Endpoint:** `POST /v1/connections/carriers/{carrier_name}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_name | String | Yes | Carrier identifier (e.g., "stamps_com", "fedex", "ups") |
| params | Hash | Yes | Carrier account connection details (nickname, account_number, credentials, etc.) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.carrier_accounts.connect('fedex', {
  nickname: 'My FedEx',
  account_number: '1234567890'
})
puts response['carrier_id']
```

### Response

```json
{
  "carrier_id": "se-fedex-1"
}
```

## disconnect

Disconnects a carrier account from your ShipEngine account.

**Method:** `client.carrier_accounts.disconnect(carrier_name, carrier_id, config: {})`

**API Endpoint:** `DELETE /v1/connections/carriers/{carrier_name}/{carrier_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_name | String | Yes | Carrier identifier (e.g., "fedex", "ups") |
| carrier_id | String | Yes | The ShipEngine carrier connection ID to disconnect |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.carrier_accounts.disconnect('fedex', 'se-fedex-1')
```

### Response

```json
{}
```

## get_settings

Retrieves settings for a connected carrier account.

**Method:** `client.carrier_accounts.get_settings(carrier_name, carrier_id, config: {})`

**API Endpoint:** `GET /v1/connections/carriers/{carrier_name}/{carrier_id}/settings`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_name | String | Yes | Carrier identifier (e.g., "fedex", "ups") |
| carrier_id | String | Yes | The ShipEngine carrier connection ID |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.carrier_accounts.get_settings('fedex', 'se-fedex-1')
puts response['nickname']
puts response['is_primary_account']
```

### Response

```json
{
  "nickname": "My FedEx",
  "is_primary_account": true
}
```

## update_settings

Updates settings for a connected carrier account.

**Method:** `client.carrier_accounts.update_settings(carrier_name, carrier_id, params, config: {})`

**API Endpoint:** `PUT /v1/connections/carriers/{carrier_name}/{carrier_id}/settings`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_name | String | Yes | Carrier identifier (e.g., "fedex", "ups") |
| carrier_id | String | Yes | The ShipEngine carrier connection ID |
| params | Hash | Yes | Updated settings (nickname, default_service_type, etc.) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.carrier_accounts.update_settings('fedex', 'se-fedex-1', { nickname: 'Updated FedEx' })
```

### Response

```json
{}
```
