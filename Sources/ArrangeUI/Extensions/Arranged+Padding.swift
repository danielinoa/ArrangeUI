//
//  Created by Daniel Inoa on 2/5/24.
//

import UIKit
import Combine

public extension Arranged {

    func padding(_ value: Double) -> Arranged {
        PaddingView(value).arrange(self)
    }

    func padding(_ insets: UIEdgeInsets) -> Arranged {
        PaddingView(insets).arrange(self)
    }

    func padding(_ subject: CurrentValueSubject<UIEdgeInsets, Never>) -> Arranged {
        PaddingMutation(
            subject: subject
        ).hosted(content: PaddingView(.zero).arrange(self))
    }
}
