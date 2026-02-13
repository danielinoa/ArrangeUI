//
//  Created by Daniel Inoa on 5/30/23.
//

import UIKit

public extension UIView {

  private static var arrangementPriorityAssociationKey: UnsafeRawPointer?

  var arrangementPriority: Int {
    get {
      objc_getAssociatedObject(self, &(Self.arrangementPriorityAssociationKey)) as? Int ?? .zero
    }
    set {
      objc_setAssociatedObject(self, &Self.arrangementPriorityAssociationKey, newValue, .OBJC_ASSOCIATION_COPY)
      setNeedsArrangement()
    }
  }
}
