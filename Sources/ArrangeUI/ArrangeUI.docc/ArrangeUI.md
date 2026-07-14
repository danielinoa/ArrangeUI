# ``ArrangeUI``

Compose UIKit view hierarchies with stacks, flows, flex layouts, and small sizing wrappers.

## Overview

ArrangeUI adapts every `UIView` to the [Arrange](https://github.com/danielinoa/Arrange) layout engine. Containers measure their subviews through UIKit's intrinsic-size and fitting-size APIs, then assign frames during `layoutSubviews()`.

Build a hierarchy declaratively while continuing to use ordinary UIKit views:

```swift
let header = HStackView(alignment: .center, spacing: 12) {
  avatar.sized(width: 44, height: 44)

  VStackView(alignment: .leading, spacing: 2) {
    nameLabel
    detailLabel
  }

  SpacerView()
  actionButton
}
```

Use Auto Layout to position the outer ArrangeUI view in an existing UIKit hierarchy. ArrangeUI manages the frames of that view's arranged descendants.

For a guided tour of composition, sizing, hosting, and invalidation, see <doc:ComposingLayouts>.

## Topics

### Essentials

- <doc:ComposingLayouts>
- ``UIViewBuilder``
- ``LayoutView``

### Stacks

- ``HStackView``
- ``VStackView``
- ``ZStackView``

### Flow and Flexible Distribution

- ``FlowView``
- ``HFlexView``
- ``VFlexView``
- ``SpacerView``

### Wrappers

- ``PaddingView``
- ``OffsetView``
- ``BackgroundView``
- ``FrameView``
- ``SizeView``

### Clamped Hosts

- ``BoundsClampedView``
- ``SafeAreaClampedView``
