//
//  Created by Daniel Inoa on 2/5/24.
//

import Arrange
import UIKit

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
