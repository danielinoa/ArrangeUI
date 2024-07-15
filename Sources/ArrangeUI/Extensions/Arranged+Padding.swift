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
            arrangedContent: PaddingView(.zero).arrange(self),
            subject: subject
        )
    }
}

private final class PaddingMutation: Hook {

    var arrangedContent: (any Arranged)?
    let subject: CurrentValueSubject<UIEdgeInsets, Never>
    var cancellables: Set<AnyCancellable> = []

    init(arrangedContent: (any Arranged)? = nil, subject: CurrentValueSubject<UIEdgeInsets, Never>) {
        self.arrangedContent = arrangedContent
        self.subject = subject
    }

    func process(_ view: UIView) {
        guard let paddingView = view as? PaddingView, cancellables.isEmpty else { return }
        subject.sink { [weak paddingView] insets in
            paddingView?.paddingLayout.insets = insets.asEdgeInsets
        }.store(in: &cancellables)
    }
}
