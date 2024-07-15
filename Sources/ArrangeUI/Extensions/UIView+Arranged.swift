//
//  Created by Daniel Inoa on 1/27/24.
//

import UIKit

extension UIView: Arranged {

    public var arrangedContent: Arranged? {
        self
    }

    public func arrange(_ items: Arranged...) -> Arranged {
        let subnodes: [BuilderNode] = items.map { $0 as? BuilderNode ?? .init(content: $0) }
        return BuilderNode(content: self, subnodes: subnodes)
    }
}
