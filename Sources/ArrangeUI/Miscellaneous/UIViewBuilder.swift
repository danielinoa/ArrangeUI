//
//  Created by Daniel Inoa on 2/13/26.
//

import UIKit

/// Builds an ordered view array from direct, conditional, and repeated `UIView` expressions.
@resultBuilder
public enum UIViewBuilder {

  public static func buildExpression(_ expression: UIView) -> [UIView] {
    [expression]
  }

  public static func buildBlock(_ components: [UIView]...) -> [UIView] {
    components.flatMap { $0 }
  }

  public static func buildOptional(_ component: [UIView]?) -> [UIView] {
    component ?? []
  }

  public static func buildEither(first component: [UIView]) -> [UIView] {
    component
  }

  public static func buildEither(second component: [UIView]) -> [UIView] {
    component
  }

  public static func buildArray(_ components: [[UIView]]) -> [UIView] {
    components.flatMap { $0 }
  }

  public static func buildLimitedAvailability(_ component: [UIView]) -> [UIView] {
    component
  }
}
