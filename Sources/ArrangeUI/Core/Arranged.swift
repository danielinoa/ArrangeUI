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
        let subnodes: [BuilderNode] = items.map { item in
            if let node = item as? BuilderNode {
                node
            } else {
                BuilderNode(content: item)
            }
        }
        if let node = self as? BuilderNode {
            node.subnodes = subnodes
            return node
        } else {
            return BuilderNode(content: self, subnodes: subnodes)
        }
    }
}

public extension Arranged {

    func constructViewTree() -> UIView? {
        if let view = self as? UIView {
            return view
        } else if let content: Arranged = self.arrangedContent, let view: UIView = content.constructViewTree() {
            // In situations where a view has subviews that are not part of the Arranged-tree, that view's sub-hierarchy
            // should not be modified. 
            // For example, an arranged UIButton's titleLabel and imageView are part of the button's view hierarchy but
            // not explictly included as part of the Arranged tree. In that case those subviews are ignored from any
            // view-hierarchy related operations.
            // `node.subnodes.hasElements` is checked to ensure the aforementioned rule.
            if let node = self as? BuilderNode, node.subnodes.hasElements {
                let subviews: [UIView] = node.subnodes.compactMap { $0.constructViewTree() }
                view.setSubviews(subviews)
            }
            if let viewModifier = self as? UIViewModifier {
                viewModifier.modify(view)
            }
            return view
        } else {
            return nil
        }
    }
}
