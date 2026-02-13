//
//  Created by Daniel Inoa on 2/26/24.
//

import UIKit
import Arrange

public final class ZStackView: LayoutView {

    public override var layout: Layout {
        get { stackLayout }
        set {
            guard let stackLayout = newValue as? ZStackLayout else { return }
            self.stackLayout = stackLayout
        }
    }

    public var stackLayout: ZStackLayout {
        didSet {
            setAncestorsNeedLayout()
        }
    }

    public init(alignment: Alignment = .center) {
        stackLayout = ZStackLayout(alignment: alignment)
        super.init(layout: stackLayout)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
