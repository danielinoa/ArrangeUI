//
//  Created by Daniel Inoa on 2/5/24.
//

import UIKit
import Combine

public extension Arranged {

    func offset(x: Double = .zero, y: Double = .zero) -> Arranged {
        OffsetView(x: x, y: y).arrange(self)
    }

    func offset(_ subject: CurrentValueSubject<Offset, Never>) -> Arranged {
        OffsetView(subject).arrange(self)
    }
}

