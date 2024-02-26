//
//  Created by Daniel Inoa on 2/26/24.
//

import UIKit

@dynamicMemberLookup
final class VStackView: LayoutView {

    override var layout: Layout {
        get { stackLayout }
        set {
            guard let stackLayout = newValue as? VStackLayout else { return }
            self.stackLayout = stackLayout
        }
    }

    private var stackLayout: VStackLayout

    init(alignment: HorizontalAlignment = .center, spacing: Double = .zero) {
        stackLayout = VStackLayout(alignment: alignment, spacing: spacing)
        super.init(layout: stackLayout)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    subscript<T>(dynamicMember keyPath: WritableKeyPath<VStackLayout, T>) -> T {
        get { stackLayout[keyPath: keyPath] }
        set { stackLayout[keyPath: keyPath] = newValue }
    }
}
