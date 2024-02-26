//
//  Created by Daniel Inoa on 2/26/24.
//

import UIKit

@dynamicMemberLookup
public final class HStackView: LayoutView {

    public override var layout: Layout {
        get { stackLayout }
        set {
            guard let stackLayout = newValue as? HStackLayout else { return }
            self.stackLayout = stackLayout
        }
    }

    private var stackLayout: HStackLayout

    public init(alignment: VerticalAlignment = .center, spacing: Double = .zero) {
        stackLayout = HStackLayout(alignment: alignment, spacing: spacing)
        super.init(layout: stackLayout)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<HStackLayout, T>) -> T {
        get { stackLayout[keyPath: keyPath] }
        set { stackLayout[keyPath: keyPath] = newValue }
    }
}
