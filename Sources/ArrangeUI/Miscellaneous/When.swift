//
//  Created by Daniel Inoa on 1/11/24.
//

import Combine

public final class When: Arranged, LayoutObservable {

    public weak var observer: LayoutObserver?

    private let contentProvider: () -> Arranged?
    private let subject: CurrentValueSubject<Bool, Never>
    private var cancellables: Set<AnyCancellable> = []

    public init(
        _ subject: CurrentValueSubject<Bool, Never>,
        _ contentProvider: @escaping () -> Arranged?
    ) {
        self.subject = subject
        self.contentProvider = contentProvider
        subject.sink { [weak self] _ in
            self?.observer?.invalidate()
        }
        .store(in: &cancellables)
    }

    public var arrangedContent: Arranged? {
        if subject.value, let content = contentProvider() {
            BuilderNode(content: content)
        } else {
            nil
        }
    }
}

extension Arranged {

    public func when(_ subject: CurrentValueSubject<Bool, Never>) -> Arranged {
        When(subject, { self })
    }
}
