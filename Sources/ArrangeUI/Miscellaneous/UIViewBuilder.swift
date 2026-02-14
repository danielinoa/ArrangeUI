//
//  Created by Daniel Inoa on 2/13/26.
//

import UIKit

@resultBuilder
public enum UIViewBuilder {

  public static func buildBlock(_ components: UIView...) -> [UIView] {
    components
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
}
