//
//  Created by Daniel Inoa on 5/26/23.
//

import UIKit
import Combine
import Rectangular

@dynamicMemberLookup
public class PaddingView: LayoutView {

    public var insets: UIEdgeInsets {
        get { subject.value }
        set { subject.value = newValue }
    }

    public override var layout: Layout {
        get { paddingLayout }
        set {
            guard let paddingLayout = newValue as? PaddingLayout else { return }
            self.paddingLayout = paddingLayout
        }
    }

    private var paddingLayout: PaddingLayout {
        didSet {
            setAncestorsNeedLayout()
        }
    }

    // MARK: - Observation

    private let subject: CurrentValueSubject<UIEdgeInsets, Never>
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    public convenience init(_ value: Double) {
        let insets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        self.init(insets)
    }

    public convenience init(_ insets: UIEdgeInsets) {
        let subject = CurrentValueSubject<UIEdgeInsets, Never>(insets)
        self.init(subject)
    }

    public init(_ subject: CurrentValueSubject<UIEdgeInsets, Never>) {
        self.subject = subject
        paddingLayout = PaddingLayout(insets: subject.value.asEdgeInsets)
        super.init(layout: paddingLayout)
        subject.sink { [weak self] insets in
            self?.paddingLayout.insets = insets.asEdgeInsets
        }.store(in: &cancellables)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<PaddingLayout, T>) -> T {
        get { paddingLayout[keyPath: keyPath] }
        set { paddingLayout[keyPath: keyPath] = newValue }
    }
}

public extension UIView {

    func padding(_ subject: CurrentValueSubject<UIEdgeInsets, Never>) -> PaddingView {
        let paddingView = PaddingView(subject)
        paddingView.addSubview(self)
        return paddingView
    }

    func padding(_ value: Double) -> PaddingView {
        let insets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        let subject = CurrentValueSubject<UIEdgeInsets, Never>(insets)
        let paddingView = PaddingView(subject)
        paddingView.addSubview(self)
        return paddingView
    }

    func padding(_ insets: UIEdgeInsets) -> PaddingView {
        let subject = CurrentValueSubject<UIEdgeInsets, Never>(insets)
        let paddingView = PaddingView(subject)
        paddingView.addSubview(self)
        return paddingView
    }
}
