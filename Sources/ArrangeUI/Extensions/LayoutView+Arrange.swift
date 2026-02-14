//
//  Created by Daniel Inoa on 2/13/26.
//

import UIKit

public extension LayoutView {

  @discardableResult
  func arrange(_ views: UIView...) -> Self {
    views.forEach(addSubview)
    return self
  }

  @discardableResult
  func arrange(@UIViewBuilder _ content: () -> [UIView]) -> Self {
    content().forEach(addSubview)
    return self
  }
}
