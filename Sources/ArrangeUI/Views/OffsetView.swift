//
//  Created by Daniel Inoa on 6/17/23.
//

import UIKit
import Rectangular

public class OffsetView: LayoutView {

    public override var layout: Layout {
        get { offsetLayout }
        set {
            guard let offsetLayout = newValue as? OffsetLayout else { return }
            self.offsetLayout = offsetLayout
        }
    }

    public var offsetLayout: OffsetLayout {
        didSet {
            setAncestorsNeedLayout()
        }
    }

    // MARK: - Lifecycle

    public init(x: Double, y: Double) {
        offsetLayout = OffsetLayout(x: x, y: y)
        super.init(layout: offsetLayout)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
