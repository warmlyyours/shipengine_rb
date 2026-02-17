# Addresses

Validate and parse shipping addresses.

## validate

Validate one or more addresses against the ShipEngine address validation service.

**Method:** `client.addresses.validate(addresses, config: {})`

**API Endpoint:** `POST /v1/addresses/validate`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| addresses | Array<Hash> | Yes | Array of address hashes to validate |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.addresses.validate([{
  country_code: 'US',
  address_line1: '4 Jersey St.',
  address_line2: 'Suite 200',
  address_line3: '2nd Floor',
  city_locality: 'Boston',
  state_province: 'MA',
  postal_code: '02215'
}])
```

### Response

```json
[
  {
    "status": "verified",
    "original_address": {
      "name": null,
      "company_name": null,
      "address_line1": "4 Jersey St.",
      "address_line2": "Suite 200",
      "address_line3": "2nd Floor",
      "phone": null,
      "city_locality": "Boston",
      "state_province": "MA",
      "postal_code": "02215",
      "country_code": "US",
      "address_residential_indicator": "unknown"
    },
    "matched_address": {
      "name": null,
      "company_name": null,
      "address_line1": "4 JERSEY ST STE 200",
      "address_line2": "",
      "address_line3": "2ND FLOOR",
      "phone": null,
      "city_locality": "BOSTON",
      "state_province": "MA",
      "postal_code": "02215-4148",
      "country_code": "US",
      "address_residential_indicator": "no"
    },
    "messages": []
  }
]
```

## parse

Parse an address from free-form text. Recognizes and extracts address components (street, city, state, postal code, country) from unstructured text.

**Method:** `client.addresses.parse(text, config: {})`

**API Endpoint:** `PUT /v1/addresses/recognize`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| text | Hash | Yes | Request body with `text` key containing the address string to parse |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.addresses.parse({
  text: 'I need to ship to 525 S Winchester Blvd, San Jose CA 95128'
})
```

### Response

```json
{
  "score": 0.97,
  "address": {
    "address_line1": "525 S Winchester Blvd",
    "city_locality": "San Jose",
    "state_province": "CA",
    "postal_code": "95128",
    "country_code": "US"
  },
  "entities": []
}
```
