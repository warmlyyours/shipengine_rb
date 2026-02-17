# Insurance

Manage Shipsurance insurance for your ShipEngine account. Get balance, add funds, and connect or disconnect Shipsurance.

## get_balance

Retrieves the current Shipsurance insurance balance.

**Method:** `client.insurance.get_balance(config: {})`

**API Endpoint:** `GET /v1/insurance/shipsurance/balance`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.insurance.get_balance
puts response['currency']
puts response['amount']
```

### Response

```json
{
  "currency": "usd",
  "amount": 100.5
}
```

## add_funds

Adds funds to your Shipsurance insurance balance.

**Method:** `client.insurance.add_funds(params, config: {})`

**API Endpoint:** `PATCH /v1/insurance/shipsurance/add_funds`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Currency and amount to add (currency, amount) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.insurance.add_funds({ currency: 'usd', amount: 50.00 })
puts response['amount']
```

### Response

```json
{
  "currency": "usd",
  "amount": 150.5
}
```

## connect

Connects Shipsurance insurance to your ShipEngine account.

**Method:** `client.insurance.connect(config: {})`

**API Endpoint:** `POST /v1/connections/insurance/shipsurance`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.insurance.connect
```

### Response

```json
{}
```

## disconnect

Disconnects Shipsurance insurance from your ShipEngine account.

**Method:** `client.insurance.disconnect(config: {})`

**API Endpoint:** `DELETE /v1/connections/insurance/shipsurance`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| config | Hash | No | Per-request config overrides |

### Example

```ruby
client.insurance.disconnect
```

### Response

```json
{}
```
