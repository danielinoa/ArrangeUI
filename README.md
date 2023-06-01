# ArrangeUI

## Introduction

### What

`ArrangeUI` is a library to supplement UIKit with views that use a layout strategy similar to that of SwiftUI.

This library (`HStackView`, `VStackView`, `PaddingView`, `SpacerView`, etc) makes it easy to build layouts and UI that would otherwise be cumbersome to build with: resizing-masks, AutoLayout, or raw frame-based layouts.

### How

The layout strategy works as follows: _a parent view proposes a size to its child view, typically its bounds, and the child responds with its ideal fitting size. The parent-view honors the child-view's reported size and positions it accordingly._

All `ArrangeUI` views are frame-based under-the-hood and fully compatible with all the aforementioned approaches used in UIKit. 
To accomplish this SwiftUI-like layout `ArrangeUI` views leverage the `UIView`'s existing arrangement methods (`intrinsicContentSize`, `sizeThatFits`, and `layoutSubviews`) and tap into the UIKit view-tree render mechanism.

### Why

This library is intended for UIKit developers that want to leverage SwiftUI layout strategies but aren't ready or interested in making a full transition to SwiftUI.
Additionally, this library provides insight into how SwiftUI views and layouts may be implemented under-the-hood.

# Usage

## Installation

To install using Swift Package Manager, add this to the dependencies section in your `Package.swift` file:

```swift
.package(url: "https://github.com/danielinoa/ArrangeUI.git", .branch("main"))
```

# Contributing

Feel free to open an issue if you have questions about how to use `ArrangeUI`, discovered a bug, or want to improve the implementation or interface.

# Credits

`ArrangeUI` is primarily the work of [Daniel Inoa](https://github.com/danielinoa).
