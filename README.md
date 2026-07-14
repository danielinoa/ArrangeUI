# ArrangeUI

`ArrangeUI` is a lightweight UIKit wrapper around the [Arrange](https://github.com/danielinoa/Arrange) layout engine. It brings composable, SwiftUI-like layout primitives to UIKit while keeping every element a `UIView`.

ArrangeUI is intended for programmatic UIKit. Its layout views do not support storyboard or nib decoding.

## Requirements

- iOS 13 or later
- Swift 6.2 or later
- Xcode 26 or later

## Installation

Add ArrangeUI to your Swift package dependencies:

```swift
dependencies: [
  .package(url: "https://github.com/danielinoa/ArrangeUI.git", branch: "main")
]
```

Then add the product to your target:

```swift
.target(
  name: "YourApp",
  dependencies: [
    .product(name: "ArrangeUI", package: "ArrangeUI")
  ]
)
```

ArrangeUI currently tracks `main`; use the same branch requirement until a versioned release is available.

## Quick Start

Build a hierarchy with a view builder, then host its root in Auto Layout like any other view:

```swift
import ArrangeUI
import UIKit

@MainActor
final class ProfileViewController: UIViewController {

  private let avatar = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))

  private lazy var content: UIView = VStackView(alignment: .leading, spacing: 8) {
    avatar.sized(width: 56, height: 56)
    makeLabel("Ada Lovelace", style: .headline)
    makeLabel("UIKit views, arranged compositionally", style: .subheadline)
  }
  .padding(20)
  .background(alignment: .center) {
    let background = UIView()
    background.backgroundColor = .secondarySystemBackground
    background.layer.cornerRadius = 16
    return background
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    view.addSubview(content)
    content.translatesAutoresizingMaskIntoConstraints = false

    let guide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      content.topAnchor.constraint(equalTo: guide.topAnchor, constant: 24),
      content.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
      content.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
      content.bottomAnchor.constraint(lessThanOrEqualTo: guide.bottomAnchor, constant: -24)
    ])
  }

  private func makeLabel(_ text: String, style: UIFont.TextStyle) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = .preferredFont(forTextStyle: style)
    label.numberOfLines = 0
    return label
  }
}
```

ArrangeUI lays out the descendants inside `content`; Auto Layout positions `content` in the view controller. Do not add constraints between children managed by an ArrangeUI container.

## Layout Primitives

| Primitive | Purpose |
| --- | --- |
| `HStackView`, `VStackView` | Arrange views in one row or column with spacing and cross-axis alignment. |
| `ZStackView` | Overlay views using a shared alignment. |
| `FlowView` | Wrap intrinsic-sized views into rows. |
| `HFlexView`, `VFlexView` | Distribute views across the container's available primary axis. |
| `SpacerView` | Consume proposed space along an inferred or explicit axis. |
| `PaddingView`, `OffsetView`, `BackgroundView` | Wrap a view with insets, an offset, or a background. |
| `FrameView` | Give a child a fixed or constrained layout region and align it within that region. |
| `SizeView` | Force specified dimensions on the wrapped view. |
| `BoundsClampedView`, `SafeAreaClampedView` | Center content and clamp it to the host's bounds or safe area. |
| `LayoutView` | Host any custom `Arrange.Layout`. |

The wrapper views are also available through fluent helpers:

```swift
let card = label
  .padding(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
  .background {
    let view = UIView()
    view.backgroundColor = .tertiarySystemBackground
    view.layer.cornerRadius = 10
    return view
  }
  .frame(maximumWidth: 320, alignment: .leading)
  .offset(y: 4)
```

## Builder Composition

Stack, flow, and flex initializers accept `UIViewBuilder`. The builder supports ordinary views, optional branches, `if`/`else`, and `for` loops:

```swift
let showsDetail = true
let actions = [editButton, shareButton]

let content = VStackView(alignment: .leading, spacing: 12) {
  titleLabel

  if showsDetail {
    detailLabel
  }

  HStackView(spacing: 8) {
    for action in actions {
      action
    }
  }
}
```

You can add content later with `arrange`:

```swift
let row = HStackView(alignment: .center, spacing: 8)

row.arrange(iconView, titleLabel)
row.arrange {
  subtitleLabel
  disclosureView
}
```

Each view can have only one superview, just as in regular UIKit.

## Flow and Flex Layouts

Use `FlowView` for intrinsic-sized items that should wrap when the proposed width is exhausted:

```swift
let topics = ["UIKit", "Layout", "Accessibility", "Swift"]

let tagCloud = FlowView(
  horizontalAlignment: .leading,
  verticalAlignment: .center,
  horizontalSpacing: 8,
  verticalSpacing: 8
) {
  for topic in topics {
    makePill(topic)
  }
}

func makePill(_ text: String) -> UIView {
  let label = UILabel()
  label.text = text

  let fill = UIView()
  fill.backgroundColor = .tertiarySystemFill
  fill.layer.cornerRadius = 8

  return label.padding(
    UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
  ).background(alignment: .center, fill)
}
```

Use flex views when the container should distribute leftover space. `HFlexView` supports leading, center, trailing, space-between, space-around, and space-evenly distributions; `VFlexView` provides the corresponding vertical distributions.

```swift
let toolbar = HFlexView(distribution: .spaceBetween, alignment: .center) {
  backButton
  titleLabel
  doneButton
}

let evenlySpacedSteps = VFlexView(distribution: .spaceEvenly, alignment: .leading) {
  firstStep
  secondStep
  thirdStep
}
```

Flow and flex placement depends on the container's available bounds, so give the container a width or height through its parent layout or Auto Layout constraints.

## Spacers and Priorities

Use `SpacerView` to consume remaining horizontal space in an `HStackView` or vertical space in a `VStackView`:

```swift
let row = HStackView(alignment: .center, spacing: 8) {
  avatarView
  nameLabel
  SpacerView()
  followButton
}
```

Pass an explicit `axisBehavior` when stack inference is not appropriate. `minLength` is the minimum size of the spacer's non-expanding axis. Flex views distribute leftover space through their `distribution`; a spacer does not create an expanding flex gap.

Stacks allocate constrained space to higher-priority views first. Every ordinary view starts at priority `0`; a spacer starts at `-1` so content wins before the spacer:

```swift
nameLabel.arrangementPriority = 1
followButton.arrangementPriority = 2
```

Use priorities to express relative importance, not exact sizes. Use `sized` or `frame` when a dimension must be explicit.

## `SizeView` vs. `FrameView`

Choose based on whether the child or its surrounding layout region should be constrained:

| Use | Behavior | Example |
| --- | --- | --- |
| `SizeView` / `sized` | Forces each specified dimension on the child, independent of that dimension's proposal. | `icon.sized(width: 24, height: 24)` |
| `FrameView` / `frame` | Proposes a fixed or min/max-constrained region, then aligns the child's fitting size within it. | `label.frame(maximumWidth: .infinity, alignment: .leading)` |

For example, keep an image at exactly 32 points while allowing a label's region to occupy the remaining width:

```swift
let row = HStackView(spacing: 12) {
  imageView.sized(width: 32, height: 32)
  titleLabel.frame(maximumWidth: .infinity, alignment: .leading)
}
```

`FrameView(width:height:)` fixes the wrapper's region. Its child still receives a proposal and is positioned using the frame's alignment. `SizeView` directly controls the wrapped view's dimensions.

## Bounds and Safe-Area Clamping

Use a clamped host when content should retain its preferred size until the available region becomes smaller:

```swift
let host = SafeAreaClampedView()
host.addSubview(content)

view.addSubview(host)
host.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
  host.topAnchor.constraint(equalTo: view.topAnchor),
  host.leadingAnchor.constraint(equalTo: view.leadingAnchor),
  host.trailingAnchor.constraint(equalTo: view.trailingAnchor),
  host.bottomAnchor.constraint(equalTo: view.bottomAnchor)
])
```

`BoundsClampedView` uses its complete bounds. `SafeAreaClampedView` uses the inset safe-area bounds and includes those insets in its reported size. Both center their subviews, report their largest child's preferred size, and clamp child frames to the available region.

## Updating Layout

Changing container properties such as spacing, alignment, or distribution automatically invalidates the ArrangeUI hierarchy. After changing content that affects a child's intrinsic size, explicitly propagate the invalidation when UIKit does not do so for you:

```swift
titleLabel.text = updatedTitle
titleLabel.setNeedsArrangement()
```

`setNeedsArrangement()` invalidates intrinsic size and marks the view and all ancestors as needing layout. `arrangeIfNeededNow()` performs an immediate layout pass from the root ancestor; reserve it for code that needs frames synchronously.

Typed containers expose their matching layout through properties such as `stackLayout`, `flowLayout`, or `flexLayout`. Assigning an incompatible value to their general `layout` property fails immediately; use `LayoutView` when the layout type needs to vary.

For specialized rendering, `LayoutView.layoutSubviewsStrategy` receives all proposed `(view, frame)` pairs and replaces the default frame assignment:

```swift
stack.layoutSubviewsStrategy = { pairs in
  for pair in pairs {
    pair.view.frame = pair.frame.integral
  }
}
```

The strategy is retained by its layout view. Capture the layout view or its owner weakly if the closure refers back to either one.

## Development

`swift test` targets macOS and cannot build this UIKit-only package. From the repository root, build the package scheme with Xcode:

```sh
xcodebuild build \
  -scheme ArrangeUI \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO
```

For tests, select the first installed iOS simulator without depending on a model name or OS version:

```sh
SIMULATOR_ID="$(
  xcrun simctl list devices iOS |
    sed -nE 's/.*\(([0-9A-F-]{36})\) \((Booted|Shutdown)\).*/\1/p' |
    head -n 1
)"
test -n "$SIMULATOR_ID"

xcodebuild test \
  -scheme ArrangeUI \
  -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
  CODE_SIGNING_ALLOWED=NO
```

## Contributing

Issues and pull requests are welcome, especially around layout correctness, API ergonomics, tests, and examples.

## Credits

ArrangeUI is primarily the work of [Daniel Inoa](https://github.com/danielinoa).

## License

ArrangeUI is available under the [MIT License](LICENSE).
