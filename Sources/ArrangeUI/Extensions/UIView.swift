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
