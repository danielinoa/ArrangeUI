//
//  Created by Daniel Inoa on 2/5/24.
//

import UIKit
import Combine

public extension Arranged {

    func offset(x: Double = .zero, y: Double = .zero) -> Arranged {
        OffsetView(x: x, y: y).arrange(self)
    }

    func offset(_ subject: CurrentValueSubject<(x: Double, y: Double), Never>) -> Arranged {
        OffsetMutation(
            arrangedContent: PaddingView(.zero).arrange(self),
            subject: subject
        )
    }
}

private final class OffsetMutation: Hook {

    var arrangedContent: (any Arranged)?
    let subject: CurrentValueSubject<(x: Double, y: Double), Never>
    var cancellables: Set<AnyCancellable> = []

    init(arrangedContent: (any Arranged), subject: CurrentValueSubject<(x: Double, y: Double), Never>) {
        self.arrangedContent = arrangedContent
        self.subject = subject
    }

    func process(_ view: UIView) {
        guard let offsetView = view as? OffsetView, cancellables.isEmpty else { return }
        subject.sink { [weak offsetView] offset in
            offsetView?.offsetLayout.x = offset.x
            offsetView?.offsetLayout.y = offset.y
        }.store(in: &cancellables)
    }
}
