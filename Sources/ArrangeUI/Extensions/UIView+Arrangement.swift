//
//  Created by Daniel Inoa on 5/25/23.
//

import UIKit

public extension UIView {

    func setNeedsArrangement() {
        setNeedsLayout()
        if let superview {
            superview.setNeedsArrangement()
        } else {
            cascadeLayoutIfNeeded()
        }
    }

    private func cascadeLayoutIfNeeded() {
        layoutIfNeeded()
        subviews.forEach { $0.cascadeLayoutIfNeeded() }
    }
}
