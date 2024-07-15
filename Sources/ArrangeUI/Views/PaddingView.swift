//
//  Created by Daniel Inoa on 5/26/23.
//

import UIKit
import Rectangular

public class PaddingView: LayoutView {

    public override var layout: Layout {
        get { paddingLayout }
        set {
            guard let paddingLayout = newValue as? PaddingLayout else { return }
            self.paddingLayout = paddingLayout
        }
    }

    public var paddingLayout: PaddingLayout {
        didSet {
            setAncestorsNeedLayout()
        }
    }

    // MARK: - Lifecycle

    public convenience init(_ value: Double) {
        let insets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        self.init(insets)
    }

    public init(_ insets: UIEdgeInsets) {
        paddingLayout = PaddingLayout(insets: insets.asEdgeInsets)
        super.init(layout: paddingLayout)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension UIView {

//    func padding(_ value: Double) -> PaddingView {
//        let insets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
//        let paddingView = PaddingView(insets)
//        paddingView.addSubview(self)
//        return paddingView
//    }
//
//    func padding(_ insets: UIEdgeInsets) -> PaddingView {
//        let paddingView = PaddingView(insets)
//        paddingView.addSubview(self)
//        return paddingView
//    }
}
