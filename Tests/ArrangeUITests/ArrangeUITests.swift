//
//  Created by Daniel Inoa on 5/30/23.
//

import XCTest
import UIKit
import ArrangeUI

final class ArrangeUITests: XCTestCase {

  func testHStackLayoutAppliesSpacingAndAlignment() {
    let stack = HStackView(alignment: .bottom, spacing: 8)
    let first = FixedSizeView(size: .init(width: 20, height: 10))
    let second = FixedSizeView(size: .init(width: 30, height: 20))

    stack.arrange(first, second)
    stack.frame = .init(x: .zero, y: .zero, width: 100, height: 40)
    stack.layoutIfNeeded()

    XCTAssertEqual(first.frame, .init(x: 0, y: 30, width: 20, height: 10))
    XCTAssertEqual(second.frame, .init(x: 28, y: 20, width: 30, height: 20))
  }

  func testVStackLayoutAppliesSpacingAndAlignment() {
    let stack = VStackView(alignment: .trailing, spacing: 5)
    let first = FixedSizeView(size: .init(width: 10, height: 12))
    let second = FixedSizeView(size: .init(width: 30, height: 20))

    stack.arrange(first, second)
    stack.frame = .init(x: .zero, y: .zero, width: 50, height: 100)
    stack.layoutIfNeeded()

    XCTAssertEqual(first.frame, .init(x: 40, y: 0, width: 10, height: 12))
    XCTAssertEqual(second.frame, .init(x: 20, y: 17, width: 30, height: 20))
  }

  func testZStackLayoutAppliesAlignment() {
    let stack = ZStackView(alignment: .topTrailing)
    let first = FixedSizeView(size: .init(width: 20, height: 10))
    let second = FixedSizeView(size: .init(width: 30, height: 15))

    stack.arrange(first, second)
    stack.frame = .init(x: .zero, y: .zero, width: 100, height: 40)
    stack.layoutIfNeeded()

    XCTAssertEqual(first.frame, .init(x: 80, y: 0, width: 20, height: 10))
    XCTAssertEqual(second.frame, .init(x: 70, y: 0, width: 30, height: 15))
  }

  func testPaddingViewInsetsChildAndAffectsIntrinsicSize() {
    let child = FixedSizeView(size: .init(width: 20, height: 10))
    let padding = PaddingView(.init(top: 1, left: 2, bottom: 3, right: 4))
    padding.addSubview(child)

    XCTAssertEqual(padding.intrinsicContentSize, .init(width: 26, height: 14))

    padding.frame = .init(x: .zero, y: .zero, width: 80, height: 40)
    padding.layoutIfNeeded()

    XCTAssertEqual(child.frame, .init(x: 2, y: 1, width: 20, height: 10))
  }

  func testOffsetViewShiftsChildFrame() {
    let child = FixedSizeView(size: .init(width: 20, height: 10))
    let offset = OffsetView(x: 5, y: -3)
    offset.addSubview(child)

    offset.frame = .init(x: .zero, y: .zero, width: 100, height: 40)
    offset.layoutIfNeeded()

    XCTAssertEqual(child.frame, .init(x: 45, y: 12, width: 20, height: 10))
  }

  func testFrameViewFixedDimensionsAffectPreferredSize() {
    let child = FixedSizeView(size: .init(width: 10, height: 10))
    let frame = FrameView(width: 40, height: 20)
    frame.addSubview(child)

    XCTAssertEqual(frame.intrinsicContentSize, .init(width: 40, height: 20))
    XCTAssertEqual(frame.sizeThatFits(.init(width: 200, height: 200)), .init(width: 40, height: 20))
  }

  func testSizeViewForcesDimensionsAndCentersChild() {
    let child = FixedSizeView(size: .init(width: 20, height: 10), fittingSize: .init(width: 30, height: 15))
    let sized = child.sized(width: 50, height: 40)

    XCTAssertEqual(sized.intrinsicContentSize, .init(width: 50, height: 40))
    XCTAssertEqual(sized.sizeThatFits(.init(width: 200, height: 200)), .init(width: 50, height: 40))

    sized.frame = .init(x: .zero, y: .zero, width: 80, height: 60)
    sized.layoutIfNeeded()

    XCTAssertEqual(child.frame, .init(x: 15, y: 10, width: 50, height: 40))
  }

  func testBackgroundViewIgnoresRearviewForSizingAndKeepsItAtBack() {
    let front = FixedSizeView(size: .init(width: 40, height: 20))
    let rear = FixedSizeView(size: .init(width: 120, height: 90))
    let background = front.background(alignment: .center, rear)

    XCTAssertEqual(background.intrinsicContentSize, .init(width: 40, height: 20))

    background.frame = .init(x: .zero, y: .zero, width: 100, height: 80)
    background.layoutIfNeeded()

    XCTAssertEqual(background.subviews.first, rear)
  }

  func testBoundsClampedViewClampsChildToBounds() {
    let container = BoundsClampedView()
    let child = FixedSizeView(size: .init(width: 10, height: 10), fittingSize: .init(width: 100, height: 50))
    container.addSubview(child)

    container.frame = .init(x: .zero, y: .zero, width: 30, height: 20)
    container.layoutIfNeeded()

    XCTAssertEqual(child.frame, .init(x: 0, y: 0, width: 30, height: 20))
  }

  func testSafeAreaClampedViewClampsWithinSafeAreaBounds() {
    let container = SafeAreaClampedView()
    let child = FixedSizeView(size: .init(width: 10, height: 10), fittingSize: .init(width: 200, height: 200))
    container.addSubview(child)

    container.frame = .init(x: .zero, y: .zero, width: 100, height: 80)
    container.layoutIfNeeded()

    XCTAssertEqual(child.frame, .init(x: 0, y: 0, width: 100, height: 80))
  }

  func testArrangeVariadicAddsSubviewsAndReturnsSelf() {
    let stack = HStackView()
    let first = UIView()
    let second = UIView()

    let returned = stack.arrange(first, second)

    XCTAssertTrue(returned === stack)
    XCTAssertEqual(stack.subviews, [first, second])
  }

  func testArrangeBuilderAddsSubviewsAndReturnsSelf() {
    let stack = HStackView()
    let first = UIView()
    let second = UIView()

    let returned = stack.arrange {
      first
      second
    }

    XCTAssertTrue(returned === stack)
    XCTAssertEqual(stack.subviews, [first, second])
  }

  func testSpacerAutomaticBehaviorFollowsContainingLayout() {
    let container = LayoutView(layout: HStackLayout())
    let spacer = SpacerView(minLength: 7)
    container.addSubview(spacer)

    XCTAssertEqual(spacer.sizeThatFits(.init(width: 120, height: 30)), .init(width: 120, height: 7))

    container.layout = VStackLayout()
    XCTAssertEqual(spacer.sizeThatFits(.init(width: 120, height: 30)), .init(width: 7, height: 30))

    container.layout = ZStackLayout()
    XCTAssertEqual(spacer.sizeThatFits(.init(width: 120, height: 30)), .init(width: 120, height: 30))
  }

  func testSpacerExplicitAxisOverridesAutomaticResolution() {
    let container = LayoutView(layout: HStackLayout())
    let spacer = SpacerView(axisBehavior: .vertical, minLength: 9)
    container.addSubview(spacer)

    XCTAssertEqual(spacer.sizeThatFits(.init(width: 100, height: 25)), .init(width: 9, height: 25))
  }

  func testFlowAndFlexBuilderConvenienceInitializersAttachSubviews() {
    let flowFirst = UIView()
    let flowSecond = UIView()
    let flow = FlowView {
      flowFirst
      flowSecond
    }
    XCTAssertEqual(flow.subviews, [flowFirst, flowSecond])

    let hflexChild = UIView()
    let hflex = HFlexView {
      hflexChild
    }
    XCTAssertEqual(hflex.subviews, [hflexChild])

    let vflexChild = UIView()
    let vflex = VFlexView {
      vflexChild
    }
    XCTAssertEqual(vflex.subviews, [vflexChild])
  }
}

private final class FixedSizeView: UIView {
  private let size: CGSize
  private let fittingSize: CGSize

  init(size: CGSize, fittingSize: CGSize? = nil) {
    self.size = size
    self.fittingSize = fittingSize ?? size
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var intrinsicContentSize: CGSize {
    size
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    fittingSize
  }
}
