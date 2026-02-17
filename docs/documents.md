# Documents

Create and manage shipping documents. Supports combined label documents that merge multiple labels into a single file.

## create_combined_label_document

Creates a combined document from multiple labels (e.g., for batch printing).

**Method:** `client.documents.create_combined_label_document(params, config: {})`

**API Endpoint:** `POST /v1/documents/combined_labels`

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| params | Hash | Yes | Combined label options (label_ids, format, layout, etc.) |
| config | Hash | No | Per-request config overrides |

### Example

```ruby
response = client.documents.create_combined_label_document({
  label_ids: ['se-label-1', 'se-label-2']
})
puts response['form_id']
puts response['pdf_url']
```

### Response

```json
{
  "form_id": "frm-1",
  "label_layout": "4x6",
  "pdf_url": "https://api.shipengine.com/v1/downloads/..."
}
```
