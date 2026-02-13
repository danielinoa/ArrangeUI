# ArrangeUI

`ArrangeUI` is a lightweight UIKit wrapper around the [Arrange](https://github.com/danielinoa/Arrange) layout engine.

The package focuses on view/layout primitives only:
- `HStackView`
- `VStackView`
- `ZStackView`
- `FrameView`
- `PaddingView`
- `OffsetView`
- `BackgroundView`
- `SizeView`
- `SpacerView`
- `BoundsClampedView`
- `SafeAreaClampedView`

The goal is to make SwiftUI-like layout composition available in UIKit, while staying fully `UIView`-based.

## Scope

ArrangeUI currently handles:
- layout wrappers
- sizing behavior (`intrinsicContentSize`, `sizeThatFits`)
- frame placement in `layoutSubviews`
- small UIView convenience APIs like `padding`, `offset`, `background`, `frame`, and `sized`

## Installation

Add ArrangeUI to your Swift Package dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/danielinoa/ArrangeUI.git", branch: "main")
]
```

Then add `"ArrangeUI"` to your target dependencies.

## Example

```swift
import UIKit
import ArrangeUI

let title = UILabel()
title.text = "ArrangeUI"

let subtitle = UILabel()
subtitle.text = "UIKit + Arrange"

let content = VStackView(alignment: .leading, spacing: 8)
content.addSubview(title)
content.addSubview(subtitle)

let card = content
    .padding(16)
    .background(UIView())
    .frame(maximumWidth: 320, alignment: .leading)
```

## Development Notes

- Platform target: iOS 13+
- `xcodebuild` is the recommended way to validate iOS builds from CLI.

## Contributing

Issues and PRs are welcome, especially around:
- layout correctness and edge cases
- API ergonomics for UIKit composition
- docs and examples

## Credits

ArrangeUI is primarily the work of [Daniel Inoa](https://github.com/danielinoa).
