//
//  Created by Daniel Inoa on 1/10/24.
//

import UIKit

public protocol Arranged {
    var arrangedContent: (any Arranged)? { get }
}

public extension Arranged {

    func arrange(_ items: Arranged...) -> Arranged {
        arrange(items: items)
    }

    func arrange(@ArrangedResultBuilder _ content: () -> [Arranged]) -> Arranged {
        arrange(items: content())
    }

    func arrange(items: [Arranged]) -> Arranged {
        let node = self as? BuilderNode ?? BuilderNode(content: self)
        node.subnodes = items.map { $0 as? BuilderNode ?? .init(content: $0) }
        return node
    }
}

public extension Arranged {

    // NOTES
    // -----
    // In situations where a view has subviews that are not part of the Arranged-tree, that view's sub-hierarchy
    // should not be modified.
    // For example, an arranged UIButton's titleLabel and imageView are part of the button's view hierarchy but
    // not explictly included as part of the Arranged tree. In that case those subviews are ignored from any
    // view-hierarchy related operations.
    // `node.subnodes.hasElements` is checked to ensure the aforementioned rule.

    func constructViewTree() -> UIView? {
        switch self {
        case let view as UIView: return view
        case let arranged as Arranged:
            guard let view = arranged.arrangedContent?.constructViewTree() else { return nil }
            if let node = arranged as? BuilderNode, node.subnodes.hasElements {
                let subviews = node.subnodes.compactMap { $0.constructViewTree() }
                view.setSubviews(subviews)
            }
            if let hook = arranged as? Hook {
                hook.viewWillBeAddedToArrangedTree(view)
            }
            return view
        default: return nil
        }
    }
}
