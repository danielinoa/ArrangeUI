//
//  Created by Daniel Inoa on 2/5/24.
//

import UIKit

public struct BorderModifier: UIViewModifier {

    public var color: UIColor = .clear
    public var width: Double = .zero
    public internal(set) var arrangedContent: Arranged?

    public init(color: UIColor, width: Double, content: Arranged) {
        self.color = color
        self.width = width
        self.arrangedContent = content
    }

    public func modify(_ view: UIView) {
        view.layer.borderWidth = width
        view.layer.borderColor = color.cgColor
    }
}

public extension Arranged {

    func border(color: UIColor, width: Double) -> Arranged {
        BorderModifier(color: color, width: width, content: self)
    }
}
