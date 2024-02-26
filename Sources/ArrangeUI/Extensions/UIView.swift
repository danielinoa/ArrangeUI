//
//  Created by Daniel Inoa on 1/4/24.
//

import UIKit

extension UIView {

    /// This function inserts and removes subviews based on the diff between the specified and existing subviews.
    @discardableResult
    func setSubviews(_ subviews: [UIView]) -> Self {
        let oldSubviews = self.subviews
        let diff = subviews.difference(from: oldSubviews)
        diff.forEach { change in
            switch change {
            case .insert(let offset, let subview, _):
                insertSubview(subview, at: offset)
            case .remove(_, let element, _):
                element.removeFromSuperview()
            }
        }
        return self
    }
}
