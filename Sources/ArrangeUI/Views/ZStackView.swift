//
//  Created by Daniel Inoa on 2/26/24.
//

import UIKit

@dynamicMemberLookup
final class ZStackView: LayoutView {

    override var layout: Layout {
        get { stackLayout }
        set {
            guard let stackLayout = newValue as? ZStackLayout else { return }
            self.stackLayout = stackLayout
        }
    }

    private var stackLayout: ZStackLayout

    init(alignment: Alignment = .center, spacing: Double = .zero) {
        stackLayout = ZStackLayout(alignment: alignment)
        super.init(layout: stackLayout)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    subscript<T>(dynamicMember keyPath: WritableKeyPath<ZStackLayout, T>) -> T {
        get { stackLayout[keyPath: keyPath] }
        set { stackLayout[keyPath: keyPath] = newValue }
    }
}
