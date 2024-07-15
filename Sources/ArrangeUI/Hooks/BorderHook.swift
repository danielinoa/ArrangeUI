//
//  Created by Daniel Inoa on 2/5/24.
//

import UIKit

public struct BorderHook: Hook {

    public var color: UIColor = .clear
    public var width: Double = .zero
    public internal(set) var arrangedContent: Arranged?

    public init(color: UIColor, width: Double, arrangedContent: Arranged) {
        self.color = color
        self.width = width
        self.arrangedContent = arrangedContent
    }

    public func viewWillBeAddedToArrangedTree(_ view: UIView) {
        view.layer.borderWidth = width
        view.layer.borderColor = color.cgColor
    }
}

public extension Arranged {

    func border(color: UIColor, width: Double) -> Arranged {
        BorderHook(color: color, width: width, arrangedContent: self)
    }
}
