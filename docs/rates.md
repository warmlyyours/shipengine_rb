# Rates

Shipping rate retrieval. Get rates for shipments, estimate rates with partial details, and perform bulk rate lookups.

## get_with_shipment_details

Gets shipping rates for a shipment with full details (carrier, service, addresses, packages). Use this when you have complete shipment information including ship-to, ship-from, and package details.

**Method:** `client.rates.get_with_shipment_details(shipment_details, config: {})`

**API Endpoint:** `POST /v1/rates`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| shipment_details | Hash | Yes | Shipment details including `rate_options`, `shipment` with `ship_to`, `ship_from`, `packages` |
| config | Hash | No | Per-request config overrides (e.g. idempotency_key) |

### shipment_details structure

| Name | Type | Required | Description |
|------|------|----------|-------------|
| rate_options | Hash | No | Options for rate retrieval (e.g. `carrier_ids`) |
| rate_options.carrier_ids | Array<String> | No | Filter rates to specific carrier IDs |
| shipment | Hash | Yes | Full shipment details |
| shipment.validate_address | String | No | Address validation level (e.g. `no_validation`) |
| shipment.ship_to | Hash | Yes | Destination address |
| shipment.ship_from | Hash | Yes | Origin address |
| shipment.packages | Array<Hash> | Yes | Package(s) with weight and dimensions |

### Example

```ruby
response = client.rates.get_with_shipment_details({
  rate_options: {
    carrier_ids: ['se-123890']
  },
  shipment: {
    validate_address: 'no_validation',
    ship_to: {
      name: 'Amanda Miller',
      phone: '555-555-5555',
      address_line1: '525 S Winchester Blvd',
      city_locality: 'San Jose',
      state_province: 'CA',
      postal_code: '95128',
      country_code: 'US',
      address_residential_indicator: 'yes'
    },
    ship_from: {
      company_name: 'Example Corp.',
      name: 'John Doe',
      phone: '111-111-1111',
      address_line1: '4009 Marathon Blvd',
      address_line2: 'Suite 300',
      city_locality: 'Austin',
      state_province: 'TX',
      postal_code: '78756',
      country_code: 'US',
      address_residential_indicator: 'no'
    },
    packages: [
      {
        weight: {
          value: 1.0,
          unit: 'ounce'
        }
      }
    ]
  }
})
```

### Response

```json
{
  "shipment_id": "se-28529731",
  "carrier_id": "se-28529731",
  "service_code": "usps_first_class_mail",
  "external_order_id": "string",
  "items": [],
  "tax_identifiers": [
    {
      "taxable_entity_type": "shipper",
      "identifier_type": "vat",
      "issuing_authority": "string",
      "value": "string"
    }
  ],
  "external_shipment_id": "string",
  "ship_date": "2018-09-23T00:00:00.000Z",
  "created_at": "2018-09-23T15:00:00.000Z",
  "modified_at": "2018-09-23T15:00:00.000Z",
  "shipment_status": "pending",
  "ship_to": {
    "name": "John Doe",
    "phone": "+1 204-253-9411 ext. 123",
    "company_name": "The Home Depot",
    "address_line1": "1999 Bishop Grandin Blvd.",
    "address_line2": "Unit 408",
    "address_line3": "Building #7",
    "city_locality": "Winnipeg",
    "state_province": "Manitoba",
    "postal_code": "78756-3717",
    "country_code": "CA",
    "address_residential_indicator": "no"
  },
  "ship_from": {
    "name": "John Doe",
    "phone": "+1 204-253-9411 ext. 123",
    "company_name": "The Home Depot",
    "address_line1": "1999 Bishop Grandin Blvd.",
    "address_line2": "Unit 408",
    "address_line3": "Building #7",
    "city_locality": "Winnipeg",
    "state_province": "Manitoba",
    "postal_code": "78756-3717",
    "country_code": "CA",
    "address_residential_indicator": "no"
  },
  "warehouse_id": "se-28529731",
  "return_to": {
    "name": "John Doe",
    "phone": "+1 204-253-9411 ext. 123",
    "company_name": "The Home Depot",
    "address_line1": "1999 Bishop Grandin Blvd.",
    "address_line2": "Unit 408",
    "address_line3": "Building #7",
    "city_locality": "Winnipeg",
    "state_province": "Manitoba",
    "postal_code": "78756-3717",
    "country_code": "CA",
    "address_residential_indicator": "no"
  },
  "confirmation": "none",
  "customs": {
    "contents": "merchandise",
    "non_delivery": "return_to_sender",
    "customs_items": []
  },
  "advanced_options": {
    "bill_to_account": null,
    "bill_to_country_code": "CA",
    "bill_to_party": "recipient",
    "bill_to_postal_code": null,
    "contains_alcohol": false,
    "delivered_duty_paid": false,
    "dry_ice": false,
    "dry_ice_weight": {
      "value": 0,
      "unit": "pound"
    },
    "non_machinable": false,
    "saturday_delivery": false,
    "use_ups_ground_freight_pricing": null,
    "freight_class": 77.5,
    "custom_field1": null,
    "custom_field2": null,
    "custom_field3": null,
    "origin_type": "pickup",
    "shipper_release": null,
    "collect_on_delivery": {
      "payment_type": "any",
      "payment_amount": {
        "currency": "usd",
        "amount": 0
      }
    }
  },
  "origin_type": "pickup",
  "insurance_provider": "none",
  "tags": [],
  "order_source_code": "amazon_ca",
  "packages": [
    {
      "package_code": "small_flat_rate_box",
      "weight": {
        "value": 0,
        "unit": "pound"
      },
      "dimensions": {
        "unit": "inch",
        "length": 0,
        "width": 0,
        "height": 0
      },
      "insured_value": {
        "0": {
          "currency": "usd",
          "amount": 0
        },
        "currency": "usd",
        "amount": 0
      },
      "tracking_number": "1Z932R800392060079",
      "label_messages": {
        "reference1": null,
        "reference2": null,
        "reference3": null
      },
      "external_package_id": "string"
    }
  ],
  "total_weight": {
    "value": 0,
    "unit": "pound"
  },
  "rate_response": {
    "rates": [
      {
        "rate_id": "se-28529731",
        "rate_type": "check",
        "carrier_id": "se-28529731",
        "shipping_amount": {
          "currency": "usd",
          "amount": 0
        },
        "insurance_amount": {
          "currency": "usd",
          "amount": 0
        },
        "confirmation_amount": {
          "currency": "usd",
          "amount": 0
        },
        "other_amount": {
          "currency": "usd",
          "amount": 0
        },
        "tax_amount": {
          "currency": "usd",
          "amount": 0
        },
        "zone": 6,
        "package_type": "package",
        "delivery_days": 5,
        "guaranteed_service": true,
        "estimated_delivery_date": "2018-09-23T00:00:00.000Z",
        "carrier_delivery_days": "string",
        "ship_date": "2021-07-23T14:49:13Z",
        "negotiated_rate": true,
        "service_type": "string",
        "service_code": "string",
        "trackable": true,
        "carrier_code": "string",
        "carrier_nickname": "string",
        "carrier_friendly_name": "string",
        "validation_status": "valid",
        "warning_messages": ["string"],
        "error_messages": ["string"]
      }
    ],
    "invalid_rates": [],
    "rate_request_id": "se-28529731",
    "shipment_id": "se-28529731",
    "created_at": "se-28529731",
    "status": "working",
    "errors": [
      {
        "error_source": "carrier",
        "error_type": "account_status",
        "error_code": "auto_fund_not_supported",
        "message": "Body of request cannot be nil."
      }
    ]
  }
}
```

---

## estimate

Estimates shipping rates with partial shipment details. Use this when you only have origin, destination, and weight—no full address or package details required.

**Method:** `client.rates.estimate(shipment_details, config: {})`

**API Endpoint:** `POST /v1/rates/estimate`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| shipment_details | Hash | Yes | Partial shipment details (carrier_ids, postal codes, country codes, weight) |
| config | Hash | No | Per-request config overrides |

### shipment_details structure

| Name | Type | Required | Description |
|------|------|----------|-------------|
| carrier_ids | Array<String> | No | Carrier IDs to get estimates for |
| from_postal_code | String | Yes | Origin postal/zip code |
| from_country_code | String | Yes | Origin country code (e.g. US) |
| to_postal_code | String | Yes | Destination postal/zip code |
| to_country_code | String | Yes | Destination country code |
| weight | Hash | Yes | Package weight with `value` and `unit` |

### Example

```ruby
response = client.rates.estimate({
  carrier_ids: ['se-123'],
  from_postal_code: '78756',
  from_country_code: 'US',
  to_postal_code: '90210',
  to_country_code: 'US',
  weight: { value: 5, unit: 'ounce' }
})
```

### Response

```json
[
  {
    "rate_type": "shipment",
    "carrier_id": "se-123",
    "service_code": "usps_priority",
    "shipping_amount": {
      "currency": "usd",
      "amount": 7.50
    }
  }
]
```

---

## get_by_id

Retrieves a single rate by ID from a previous rate lookup.

**Method:** `client.rates.get_by_id(rate_id, config: {})`

**API Endpoint:** `GET /v1/rates/{rate_id}`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| rate_id | String | Yes | The rate ID (e.g. "se-rate-1") |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.rates.get_by_id('se-rate-1')
```

### Response

```json
{
  "rate_id": "se-rate-1",
  "rate_type": "shipment"
}
```

---

## bulk

Gets shipping rates for multiple shipments in a single request. Use this for batch rate lookups when you have multiple shipment IDs.

**Method:** `client.rates.bulk(params, config: {})`

**API Endpoint:** `POST /v1/rates/bulk`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Request body with `shipment_ids` and optional `rate_options` |
| config | Hash | No | Per-request config overrides |

### params structure

| Name | Type | Required | Description |
|------|------|----------|-------------|
| shipment_ids | Array<String> | Yes | Array of shipment IDs to get rates for |
| rate_options | Hash | No | Options for rate retrieval |

### Example

```ruby
response = client.rates.bulk({
  shipment_ids: ['se-ship-1', 'se-ship-2'],
  rate_options: {}
})
```

### Response

Returns an array of rate response objects. When no rates are available, returns an empty array:

```json
[]
```
