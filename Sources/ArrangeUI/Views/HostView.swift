//
//  Created by Daniel Inoa on 1/10/24.
//

import UIKit

public final class HostView: UIView, LayoutObserver {

    private let rootNode: BuilderNode
    private(set) var rootView: UIView?

    // MARK: - Lifecycle

    public convenience init(_ arranged: Arranged) {
        if let rootNode = arranged as? BuilderNode {
            self.init(rootNode)
        } else {
            self.init(BuilderNode(content: arranged))
        }
    }

    public init(_ root: BuilderNode) {
        self.rootNode = root
        super.init(frame: .zero)
        referenceObservables(startingWith: root)
        rootView = root.constructViewTree()
        if let rootView {
            addSubview(rootView)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        rootView?.intrinsicContentSize ?? super.intrinsicContentSize
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        rootView?.sizeThatFits(size) ?? super.sizeThatFits(size)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let rootView else { return }
        rootView.frame = bounds
    }

    // MARK: - Tree Assembly

    public func invalidate() {
        rootView?.removeFromSuperview()
        rootView = nil
        if let rootView = rootNode.constructViewTree() {
            addSubview(rootView)
            self.rootView = rootView
        }
        setAncestorsNeedLayout()
    }

    private func referenceObservables(startingWith node: BuilderNode) {
        if var observable = node.arrangedContent as? LayoutObservable {
            observable.observer = self
        }
        node.subnodes.forEach { referenceObservables(startingWith: $0) }
    }
}

public extension Arranged {

    func hosted() -> HostView {
        .init(self)
    }
}
