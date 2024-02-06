//
//  Created by Daniel Inoa on 1/4/24.
//

import UIKit

public extension UIView {

    func nearestAncestorOfType(anyOf types: UIView.Type...) -> UIView? {
        var parent: UIView? = superview
        while parent.isNotNil {
            let parentType = type(of: parent!)
            if types.contains(where: { $0 == parentType }) {
                return parent
            }
            parent = parent?.superview
        }
        return nil
    }
}

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
