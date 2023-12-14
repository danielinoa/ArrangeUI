//
//  Created by Daniel Inoa on 5/18/23.
//

import UIKit
import Collections

/// A view that arranges its subviews along the horizontal axis.
public class VStackView: UIView {

    public var alignment: HorizontalAlignment {
        didSet {
            guard alignment != oldValue else { return }
            setNeedsArrangement()
        }
    }

    /// The vertical distance between adjacent items within the stack.
    public var spacing: Double {
        didSet {
            guard spacing != oldValue else { return }
            sizeProposalCache.removeAll()
            setNeedsArrangement()
        }
    }

    /// The list of views arranged by the stack view.
    public var arrangedSubviews: [UIView] = [] {
        didSet {
            sizeProposalCache.removeAll()
            let diff = (arrangedSubviews as [UIView]).difference(from: oldValue)
            diff.forEach { change in
                switch change {
                case .insert(let offset, let element, _):
                    insertSubview(element, at: offset)
                case .remove(_, let element, _):
                    element.removeFromSuperview()
                }
            }
            setNeedsArrangement()
        }
    }

    private var sizeProposalCache: [ProposedSize: PreferredSize] = [:]

    // MARK: - Lifecycle

    public init(alignment: HorizontalAlignment = .center, spacing: Double = .zero) {
        self.alignment = alignment
        self.spacing = spacing
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Hierarchy

    @discardableResult
    public func callAsFunction(@ViewBuilder _ content: () -> ViewBuilder.Composite) -> Self {
        arrangedSubviews = content().items().compactCast()
        return self
    }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        let totalGapSpacing = arrangedSubviews.hasElements ? spacing * Double(arrangedSubviews.count - 1) : .zero
        let viewsHeight = arrangedSubviews.map(\.intrinsicContentSize.height).reduce(.zero, +)
        let totalHeight = viewsHeight + totalGapSpacing
        let maxWidth = arrangedSubviews.map(\.intrinsicContentSize.width).max() ?? .zero
        return .init(width: maxWidth, height: totalHeight)
    }

    public override func sizeThatFits(_ proposedSize: ProposedSize) -> PreferredSize {
        if let cachedSize = sizeProposalCache[proposedSize] { return cachedSize }
        let totalGapSpacing = arrangedSubviews.hasElements ? spacing * Double(arrangedSubviews.count - 1) : .zero
        var availableHeight = proposedSize.height - totalGapSpacing
        var sizeTable: [UIView: CGSize] = [:]
        let groups = PriorityGroup.grouping(views: arrangedSubviews).sorted { $0.priority > $1.priority }
        for group in groups {
            let availableSize = CGSize(width: proposedSize.width, height: availableHeight)
            let (groupSizeTable, remainingHeight) = fittingSizes(for: group.views, in: availableSize)
            sizeTable.merge(groupSizeTable) { current, new in current } // No duplicate values are expected.
            availableHeight = remainingHeight
        }
        let totalHeight = sizeTable.values.map(\.height).reduce(.zero, +) + totalGapSpacing
        let maxWidth = sizeTable.values.map(\.width).max() ?? .zero
        let size = CGSize(width: maxWidth, height: totalHeight)
        sizeProposalCache[proposedSize] = size
        return size
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard arrangedSubviews.hasElements else { return }
        let totalGapSpacing = arrangedSubviews.hasElements ? spacing * Double(arrangedSubviews.count - 1) : .zero
        var availableHeight = bounds.height - totalGapSpacing
        var globalSizeTable: [UIView: CGSize] = [:]
        let groups = PriorityGroup.grouping(views: arrangedSubviews).sorted { $0.priority > $1.priority }
        for group in groups {
            let availableSize = CGSize(width: bounds.width, height: availableHeight)
            let (localSizeTable, remainingHeight) = fittingSizes(for: group.views, in: availableSize)
            globalSizeTable.merge(localSizeTable) { current, new in current } // No duplicate values are expected.
            availableHeight = remainingHeight
        }
        var topOffset = bounds.minY
        for view in arrangedSubviews {
            view.frame.origin.y = topOffset
            guard let size = globalSizeTable[view] else { fatalError("Expected a size for view: \(view)") }
            view.frame.size = size
            view.frame.origin.x = leadingOffset(for: .init(size: size), aligned: alignment, within: bounds)
            topOffset += size.height + spacing
        }
    }
}

extension VStackView {

    private func leadingOffset(for rect: CGRect, aligned: HorizontalAlignment, within bounds: CGRect) -> Double {
        let shift: Double
        switch aligned {
        case .leading: shift = .zero
        case .center: shift = (bounds.width - rect.width) / 2
        case .trailing: shift = bounds.width - rect.width
        }
        return bounds.minX + shift
    }

    private func fittingSizes(
        for views: [UIView], in size: CGSize
    ) -> (localSizeTable: [UIView: CGSize], sharedAvailableHeight: Double) {
        var localSizeTable: [UIView: CGSize] = [:]

        // The space that remains as views occupy the proposed size.
        var sharedAvailableHeight = size.height

        // The specified array of views, sorted in ascending manner based on their fitting height.
        var heightAscendingViews = views.sorted { $0.sizeThatFits(size).height < $1.sizeThatFits(size).height }

        // When calculating sizes all views start with an equal amount space within the "shared available space".
        // Any remaining space unused by a view is then returned to the "shared available space" for other views to use.
        // In order to ensure no space is wasted in the aforementioned step, the algorithm starts with the shortest view
        // and works itself towards the tallest view.
        while heightAscendingViews.hasElements {
            // An equal amount of space for views yet to be added to the size-table.
            let equallyAllottedHeight = sharedAvailableHeight / Double(heightAscendingViews.count)
            let view = heightAscendingViews.removeFirst()
            var fittingSize = view.sizeThatFits(.init(width: size.width, height: equallyAllottedHeight))
            if view is SpacerView { fittingSize.width = .zero } // FIXME: Avoid Spacer special handling.
            localSizeTable[view] = fittingSize
            sharedAvailableHeight = max(sharedAvailableHeight - fittingSize.height, .zero)
        }
        return (localSizeTable, sharedAvailableHeight)
    }
}
