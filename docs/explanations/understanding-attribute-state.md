# Understanding attribute state

At any given time an attribute can be in one of eight states.  State depends on:

- The current value of the attribute.
- The pre-defined permissible operating range or threshold for that attribute.
- The workflow the attribute is currently involved in.
- The overall context of the control system.

State is shown as an icon to the left of the attribute name in the
{term}`Block Information Panel`.

:::{note}
Prompt C will recreate all eight state icons as SVGs in
`docs/images/attribute-state/`.  Until then, existing PNG icons are referenced
from the legacy source tree and missing icons are marked as pending.
:::

## State reference

### Normal

Data is within an acceptable operating threshold or range.  For a
{term}`Parameter Attribute` this also means the value has been successfully
committed to the server.

```{figure} ../_legacy_rst/webcontrol/userguide/images/information_icon.png
:align: center
:width: 32px

Normal state icon
```

### Processing

Data has been submitted to the server or a retrieval request has been made.
A response is being awaited.

<!-- icon pending — Prompt C will create docs/images/attribute-state/processing.svg -->

*(Icon — see Prompt C)*

### Locally Edited

The value has been changed in the UI but not yet committed to the server.
The local edit has no effect on the running system and will not be saved as
part of the {term}`Design` until it is submitted.

```{figure} ../_legacy_rst/webcontrol/userguide/images/locally_edited_icon.png
:align: center
:width: 32px

Locally Edited state icon
```

### Update Error

The value submitted to the server was not accepted — typically because it
failed the validation defined in the Block specification.

<!-- icon pending — Prompt C will create docs/images/attribute-state/update-error.svg -->

*(Icon — see Prompt C)*

### Warning

An issue has been detected that requires investigation.  Data is outside
normal operating parameters but is still considered acceptable.

```{figure} ../_legacy_rst/webcontrol/userguide/images/warning_icon.png
:align: center
:width: 32px

Warning state icon
```

### Error

An issue has been detected and an error has been reported by the server.
Data is outside acceptable operating conditions; immediate action is
recommended.

```{figure} ../_legacy_rst/webcontrol/userguide/images/error_icon.png
:align: center
:width: 32px

Error state icon
```

### Invalid

The overall block context has changed since the UI was last accessed.
Displayed data may no longer be accurate or consistent with the current
{term}`Design`.

<!-- icon pending — Prompt C will create docs/images/attribute-state/invalid.svg -->

*(Icon — see Prompt C)*

### Disconnected

Communication with the block hosting the attribute has been lost by the
server.  Immediate investigation is recommended.

```{figure} ../_legacy_rst/webcontrol/userguide/images/disconnected_icon.png
:align: center
:width: 32px

Disconnected state icon
```

## Presenting status information

Within Block Information Panels, the state icon appears to the left of each
attribute name.

When viewing historical data in the
{doc}`attribute value table <../how-to/monitor-attribute-values>`,
the corresponding icon is shown against each row.

When viewing historical data in the
{doc}`attribute chart <../how-to/monitor-attribute-values>`,
the line colour reflects the alarm state.

:::{note}
Operating ranges and threshold values are not defined in the UI — they are
configured in the underlying Block specification and reflected into the UI.
Refer to the specific block documentation for details.
:::
