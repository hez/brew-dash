# Grain Father API

## Brew Sessions


Can parse the following:

  - batch_number
  - brewed_at
  - fermentation_at
  - final_gravity
  - name
  - notes
  - original_gravity
  - source
  - source_id
  - status
  - tap_number


### Metadata Parsed from Notes

Some metadata is parsed from the notes field using a format like `[attribute_name: value]`.

Currently these fields are parsed from the notes field:

  - tap_number
