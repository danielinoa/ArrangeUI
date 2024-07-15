//
//  Created by Daniel Inoa on 7/15/24.
//

import UIKit
import Combine

final class PaddingMutation: Hook {

    var arrangedContent: (any Arranged)?
    let subject: CurrentValueSubject<UIEdgeInsets, Never>
    var cancellables: Set<AnyCancellable> = []

    init(arrangedContent: (any Arranged)? = nil, subject: CurrentValueSubject<UIEdgeInsets, Never>) {
        self.arrangedContent = arrangedContent
        self.subject = subject
    }

    func viewWillBeAddedToArrangedTree(_ view: UIView) {
        guard let paddingView = view as? PaddingView, cancellables.isEmpty else { return }
        subject.sink { [weak paddingView] insets in
            paddingView?.paddingLayout.insets = insets.asEdgeInsets
        }.store(in: &cancellables)
    }
}
