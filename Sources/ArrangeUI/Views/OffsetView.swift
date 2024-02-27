//
//  Created by Daniel Inoa on 6/17/23.
//

import UIKit
import Rectangular
import Combine

@dynamicMemberLookup
public class OffsetView: LayoutView {

    public override var layout: Layout {
        get { offsetLayout }
        set {
            guard let offsetLayout = newValue as? OffsetLayout else { return }
            self.offsetLayout = offsetLayout
        }
    }

    private var offsetLayout: OffsetLayout {
        didSet {
            setAncestorsNeedLayout()
        }
    }

    // MARK: - Observation

    private let subject: CurrentValueSubject<Offset, Never>
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    public convenience init(x: Double, y: Double) {
        self.init(
            CurrentValueSubject<Offset, Never>((x, y))
        )
    }

    public init(_ subject: CurrentValueSubject<Offset, Never>) {
        self.subject = subject
        offsetLayout = OffsetLayout(x: subject.value.x, y: subject.value.y)
        super.init(layout: offsetLayout)
        subject.sink { [weak self] offset in
            self?.offsetLayout = .init(x: offset.x, y: offset.y)
        }.store(in: &cancellables)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<OffsetLayout, T>) -> T {
        get { offsetLayout[keyPath: keyPath] }
        set { offsetLayout[keyPath: keyPath] = newValue }
    }
}
