//
//  Created by Daniel Inoa on 1/27/24.
//

import UIKit
import Combine

extension UIView: Arranged {

    public var arrangedContent: Arranged? {
        self
    }

    public func arrange(_ items: Arranged...) -> Arranged {
        let subnodes: [BuilderNode] = items.map {
            if let node = $0 as? BuilderNode {
                node
            } else {
                BuilderNode(content: $0)
            }
        }
        return BuilderNode(content: self, subnodes: subnodes)
    }
}
