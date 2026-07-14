# Composing Layouts

Build ArrangeUI hierarchies from ordinary UIKit views, then attach the root to the surrounding interface.

## Understand the Layout Boundary

ArrangeUI and Auto Layout work at different levels of the same hierarchy:

1. Auto Layout gives the outer ArrangeUI view a position and available size.
2. The Arrange layout measures the outer view's children.
3. The container assigns frames to those children in `layoutSubviews()`.

Constrain the root ArrangeUI view with anchors, but don't add Auto Layout constraints between children managed by that container.

```swift
let content = VStackView(alignment: .leading, spacing: 12) {
  titleLabel
  messageLabel
  actionButton
}
.padding(20)

view.addSubview(content)
content.translatesAutoresizingMaskIntoConstraints = false

NSLayoutConstraint.activate([
  content.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
  content.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
  content.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
])
```

ArrangeUI is designed for programmatic UIKit. Its layout views don't decode from storyboards or nibs.

## Build Conditional and Repeated Content

The ``UIViewBuilder`` used by stack, flow, and flex initializers accepts `if`, `if`/`else`, optional branches, and `for` loops.

```swift
let list = VStackView(alignment: .leading, spacing: 10) {
  headingLabel

  if let summaryLabel {
    summaryLabel
  }

  for row in rowViews {
    row
  }
}
```

To append views after initialization, use `arrange(_:)` or its builder overload:

```swift
list.arrange(footerLabel)
list.arrange {
  cancelButton
  confirmButton
}
```

Adding a view moves it from its previous superview, following normal UIKit ownership rules.

## Choose a Container

Use ``HStackView`` and ``VStackView`` when items should proceed from one edge along a single axis. Use ``ZStackView`` when items should overlap.

``FlowView`` creates horizontal rows and wraps intrinsic-sized items when the available width is exhausted:

```swift
let chips = FlowView(
  direction: .forward,
  horizontalAlignment: .leading,
  verticalAlignment: .center,
  horizontalSpacing: 8,
  verticalSpacing: 8
) {
  for chip in chipViews {
    chip
  }
}
```

Use ``HFlexView`` or ``VFlexView`` when the views should be distributed across all available space:

```swift
let actions = HFlexView(distribution: .spaceEvenly, alignment: .center) {
  previousButton
  playButton
  nextButton
}
```

Flow and flex placement needs a concrete primary-axis bound. Supply it through the parent layout or through constraints on the root.

## Add Flexible Space and Protect Important Content

``SpacerView`` consumes the proposed size on its expansion axis. Automatic spacers infer horizontal expansion from horizontal stacks and vertical expansion from vertical stacks.

```swift
let navigationRow = HStackView(alignment: .center, spacing: 8) {
  backButton
  titleLabel
  SpacerView()
  menuButton
}
```

When a stack has less space than its children request, views with a higher `arrangementPriority` receive space first. Ordinary views default to `0`; spacers default to `-1`.

```swift
titleLabel.arrangementPriority = 1
menuButton.arrangementPriority = 2
```

Priority is relative. Use a sizing wrapper for exact dimensions.

Flex views distribute leftover space through their `distribution`; a spacer doesn't create an expanding flex gap.

## Choose the Right Sizing Wrapper

Use ``SizeView`` when a wrapped view must have an exact width, height, or both:

```swift
let icon = imageView.sized(width: 24, height: 24)
```

Use ``FrameView`` to create a fixed or min/max-constrained region while allowing the child to choose a fitting size inside it:

```swift
let leadingTitle = titleLabel.frame(
  minimumWidth: 120,
  maximumWidth: .infinity,
  alignment: .leading
)
```

The frame's alignment controls where the child sits when the region is larger than the child's fitting size. ``PaddingView``, ``BackgroundView``, and ``OffsetView`` add insets, a size-independent rear view, and visual displacement respectively.

Use ``BoundsClampedView`` to center content that should be no larger than a host's complete bounds. Use ``SafeAreaClampedView`` when the same rule should apply within safe-area insets; those insets are included in the safe-area host's reported size.

## Invalidate After Content Changes

Changing ArrangeUI layout properties automatically invalidates affected ancestors. When application state changes a child's intrinsic or fitting size and UIKit doesn't propagate that change, call `setNeedsArrangement()` on the child:

```swift
messageLabel.text = newMessage
messageLabel.setNeedsArrangement()
```

This invalidates intrinsic sizes and schedules layout up through the root. Call `arrangeIfNeededNow()` only when code must read the resulting frames synchronously.

## Customize Frame Application

Set ``LayoutView/layoutSubviewsStrategy`` to replace a layout view's default frame assignment. The closure receives one `(view, frame)` tuple per arranged subview.

```swift
stack.layoutSubviewsStrategy = { proposals in
  for proposal in proposals {
    proposal.view.frame = proposal.frame.integral
  }
}
```

The layout view strongly retains this closure. Use a weak capture when it refers to the layout view or its owning object.
