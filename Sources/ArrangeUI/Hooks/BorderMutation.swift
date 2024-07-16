//
//  Created by Daniel Inoa on 2/5/24.
//

import UIKit

public struct BorderMutation: Hook {

    public var color: UIColor = .clear
    public var width: Double = .zero

    public init(color: UIColor, width: Double) {
        self.color = color
        self.width = width
    }

    public func viewWillBeAddedToArrangedTree(_ view: UIView) {
        view.layer.borderWidth = width
        view.layer.borderColor = color.cgColor
    }
}

public extension Arranged {

    func border(color: UIColor, width: Double) -> Arranged {
        BorderMutation(color: color, width: width).hosted(content: self)
    }
}
