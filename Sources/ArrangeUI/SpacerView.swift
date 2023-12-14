//
//  Created by Daniel Inoa on 5/1/23.
//

import UIKit

public class SpacerView: UIView {

    // MARK: - Lifecycle

    public init() {
        super.init(frame: .zero)
        arrangementPriority = -1
        isUserInteractionEnabled = false
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        .zero
    }

    public override func sizeThatFits(_ size: ProposedSize) -> PreferredSize {
        size
    }
}
