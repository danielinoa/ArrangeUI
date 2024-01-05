//
//  Created by Daniel Inoa on 1/4/24.
//

import UIKit
import Rectangular

extension UIView: LayoutItem {

    public var priority: Int {
        arrangementPriority
    }

    public var intrinsicSize: Size {
        intrinsicContentSize.asSize
    }

    public func sizeThatFits(_ size: Size) -> Size {
        sizeThatFits(size.asCGSize).asSize
    }
}

extension UIView {

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
