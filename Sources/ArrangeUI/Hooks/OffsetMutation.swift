//
//  Created by Daniel Inoa on 7/15/24.
//

import UIKit
import Combine

final class OffsetMutation: Hook {

    let subject: CurrentValueSubject<Offset, Never>
    var cancellables: Set<AnyCancellable> = []

    init(subject: CurrentValueSubject<Offset, Never>) {
        self.subject = subject
    }

    func viewWillBeAddedToArrangedTree(_ view: UIView) {
        guard let offsetView = view as? OffsetView, cancellables.isEmpty else { return }
        subject.sink { [weak offsetView] offset in
            offsetView?.offsetLayout.x = offset.x
            offsetView?.offsetLayout.y = offset.y
        }.store(in: &cancellables)
    }
}
