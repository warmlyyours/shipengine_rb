# ShipEngine Ruby SDK - API Coverage Audit

This document compares the SDK's implemented operations against the
[ShipEngine Public OpenAPI Spec](https://shipengine.github.io/shipengine-openapi/).

**Audit Date:** 2026-02-17
**SDK Version:** 2.0.0

---

## Summary

| Status | Count |
|--------|-------|
| Implemented (v1.x, existing) | 9 |
| Newly implemented (v2.0) | ~75 |
| **Total implemented** | **~84** |
| Remaining gaps | See notes below |

---

## Coverage by Domain

### Account
| Operation | Endpoint | Status |
|-----------|----------|--------|
| Get settings | `GET /v1/account/settings` | **Implemented** |
| Update settings | `PUT /v1/account/settings` | **Implemented** |
| List images | `GET /v1/account/settings/images` | **Implemented** |
| Get image | `GET /v1/account/settings/images/{image_id}` | **Implemented** |
| Create image | `POST /v1/account/settings/images` | **Implemented** |

### Addresses
| Operation | Endpoint | Status |
|-----------|----------|--------|
| Validate addresses | `POST /v1/addresses/validate` | **Implemented** (v1.x) |
| Parse address | `PUT /v1/addresses/recognize` | **Implemented** (v2.0) |

### Batches
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List batches | `GET /v1/batches` | **Implemented** |
| Create batch | `POST /v1/batches` | **Implemented** |
| Get batch by ID | `GET /v1/batches/{batch_id}` | **Implemented** |
| Delete batch | `DELETE /v1/batches/{batch_id}` | **Implemented** |
| Update batch | `PUT /v1/batches/{batch_id}` | **Implemented** |
| Add shipments to batch | `POST /v1/batches/{batch_id}/add` | **Implemented** |
| Remove shipments from batch | `POST /v1/batches/{batch_id}/remove` | **Implemented** |
| Process batch labels | `POST /v1/batches/{batch_id}/process/labels` | **Implemented** |
| Get batch errors | `GET /v1/batches/{batch_id}/errors` | **Implemented** |

### Carrier Accounts (Connections)
| Operation | Endpoint | Status |
|-----------|----------|--------|
| Connect carrier | `POST /v1/connections/carriers/{carrier_name}` | **Implemented** |
| Disconnect carrier | `DELETE /v1/connections/carriers/{carrier_name}/{carrier_id}` | **Implemented** |
| Get carrier settings | `GET /v1/connections/carriers/{carrier_name}/{carrier_id}/settings` | **Implemented** |
| Update carrier settings | `PUT /v1/connections/carriers/{carrier_name}/{carrier_id}/settings` | **Implemented** |

### Carriers
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List carriers | `GET /v1/carriers` | **Implemented** (v1.x) |
| Get carrier by ID | `GET /v1/carriers/{carrier_id}` | **Implemented** (v2.0) |
| Disconnect carrier | `DELETE /v1/carriers/{carrier_id}` | **Implemented** (v2.0) |
| Add funds to carrier | `PUT /v1/carriers/{carrier_id}/add_funds` | **Implemented** (v2.0) |
| List carrier services | `GET /v1/carriers/{carrier_id}/services` | **Implemented** (v2.0) |
| List carrier packages | `GET /v1/carriers/{carrier_id}/packages` | **Implemented** (v2.0) |
| List carrier options | `GET /v1/carriers/{carrier_id}/options` | **Implemented** (v2.0) |

### Downloads
| Operation | Endpoint | Status |
|-----------|----------|--------|
| Download file | `GET /v1/downloads/{subpath}` | **Implemented** |

### Insurance
| Operation | Endpoint | Status |
|-----------|----------|--------|
| Get balance | `GET /v1/insurance/shipsurance/balance` | **Implemented** |
| Add funds | `PATCH /v1/insurance/shipsurance/balance` | **Implemented** |
| Connect Shipsurance | `POST /v1/connections/insurance/shipsurance` | **Implemented** |
| Disconnect Shipsurance | `DELETE /v1/connections/insurance/shipsurance` | **Implemented** |

### Labels
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List labels | `GET /v1/labels` | **Implemented** (v2.0) |
| Create label from shipment | `POST /v1/labels` | **Implemented** (v1.x) |
| Get label by ID | `GET /v1/labels/{label_id}` | **Implemented** (v2.0) |
| Create label from rate | `POST /v1/labels/rates/{rate_id}` | **Implemented** (v1.x) |
| Void label | `PUT /v1/labels/{label_id}/void` | **Implemented** (v1.x) |
| Get label by external shipment ID | `GET /v1/labels/external_shipment_id/{id}` | **Implemented** (v2.0) |
| Create return label | `POST /v1/labels/return` | **Implemented** (v2.0) |

### Manifests
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List manifests | `GET /v1/manifests` | **Implemented** |
| Create manifest | `POST /v1/manifests` | **Implemented** |
| Get manifest by ID | `GET /v1/manifests/{manifest_id}` | **Implemented** |
| Get manifest request by ID | `GET /v1/manifests/requests/{request_id}` | **Implemented** |

### Package Pickups
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List pickups | `GET /v1/pickups` | **Implemented** |
| Schedule pickup | `POST /v1/pickups` | **Implemented** |
| Get pickup by ID | `GET /v1/pickups/{pickup_id}` | **Implemented** |
| Delete pickup | `DELETE /v1/pickups/{pickup_id}` | **Implemented** |

### Package Types
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List package types | `GET /v1/packages` | **Implemented** |
| Create package type | `POST /v1/packages` | **Implemented** |
| Get package type by ID | `GET /v1/packages/{package_id}` | **Implemented** |
| Update package type | `PUT /v1/packages/{package_id}` | **Implemented** |
| Delete package type | `DELETE /v1/packages/{package_id}` | **Implemented** |

### Rates
| Operation | Endpoint | Status |
|-----------|----------|--------|
| Get rates with shipment details | `POST /v1/rates` | **Implemented** (v1.x) |
| Estimate rates | `POST /v1/rates/estimate` | **Implemented** (v2.0) |
| Get rate by ID | `GET /v1/rates/{rate_id}` | **Implemented** (v2.0) |
| Get bulk rates | `POST /v1/rates/bulk` | **Implemented** (v2.0) |

### Service Points
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List service points | `POST /v1/service_points/list` | **Implemented** |
| Get service point by ID | `GET /v1/service_points/{carrier_code}/{country_code}/{id}` | **Implemented** |

### Shipments
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List shipments | `GET /v1/shipments` | **Implemented** |
| Create shipments | `POST /v1/shipments` | **Implemented** |
| Get shipment by ID | `GET /v1/shipments/{shipment_id}` | **Implemented** |
| Update shipment | `PUT /v1/shipments/{shipment_id}` | **Implemented** |
| Cancel shipment | `PUT /v1/shipments/{shipment_id}/cancel` | **Implemented** |
| Tag shipment | `POST /v1/shipments/{shipment_id}/tags/{tag_name}` | **Implemented** |
| Untag shipment | `DELETE /v1/shipments/{shipment_id}/tags/{tag_name}` | **Implemented** |
| Get by external ID | `GET /v1/shipments/external_shipment_id/{id}` | **Implemented** |
| Parse shipment | `PUT /v1/shipments/recognize` | **Implemented** |

### Tags
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List tags | `GET /v1/tags` | **Implemented** |
| Create tag | `POST /v1/tags/{tag_name}` | **Implemented** |
| Delete tag | `DELETE /v1/tags/{tag_name}` | **Implemented** |
| Rename tag | `PUT /v1/tags/{tag_name}/{new_tag_name}` | **Implemented** |

### Tokens
| Operation | Endpoint | Status |
|-----------|----------|--------|
| Get ephemeral token | `POST /v1/tokens/ephemeral` | **Implemented** |

### Tracking
| Operation | Endpoint | Status |
|-----------|----------|--------|
| Track by label ID | `GET /v1/labels/{label_id}/track` | **Implemented** (v1.x) |
| Track by carrier + number | `GET /v1/tracking` | **Implemented** (v1.x) |
| Start tracking | `POST /v1/tracking/start` | **Implemented** (v2.0) |
| Stop tracking | `POST /v1/tracking/stop` | **Implemented** (v2.0) |

### Warehouses
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List warehouses | `GET /v1/warehouses` | **Implemented** |
| Create warehouse | `POST /v1/warehouses` | **Implemented** |
| Get warehouse by ID | `GET /v1/warehouses/{warehouse_id}` | **Implemented** |
| Update warehouse | `PUT /v1/warehouses/{warehouse_id}` | **Implemented** |
| Delete warehouse | `DELETE /v1/warehouses/{warehouse_id}` | **Implemented** |
| Update warehouse settings | `PUT /v1/warehouses/{warehouse_id}/settings` | **Implemented** |

### Webhooks
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List webhooks | `GET /v1/environment/webhooks` | **Implemented** |
| Create webhook | `POST /v1/environment/webhooks` | **Implemented** |
| Get webhook by ID | `GET /v1/environment/webhooks/{webhook_id}` | **Implemented** |
| Update webhook | `PUT /v1/environment/webhooks/{webhook_id}` | **Implemented** |
| Delete webhook | `DELETE /v1/environment/webhooks/{webhook_id}` | **Implemented** |

---

## Notes

All previously missing domains and operations identified in the v1.x audit have now been
implemented in v2.0.0. The SDK provides full coverage of the ShipEngine v1 REST API.
