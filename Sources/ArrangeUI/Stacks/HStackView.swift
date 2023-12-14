//
//  Created by Daniel Inoa on 4/30/23.
//

import Collections
import UIKit

/// A view that arranges its subviews along the horizontal axis.
public class HStackView: UIView {

    public var alignment: VerticalAlignment {
        didSet {
            guard alignment != oldValue else { return }
            setNeedsArrangement()
        }
    }

    /// The horizontal distance between adjacent items within the stack.
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

    public init(alignment: VerticalAlignment = .center, spacing: Double = .zero) {
        self.alignment = alignment
        self.spacing = spacing
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
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
        let viewsWidth = arrangedSubviews.map(\.intrinsicContentSize.width).reduce(.zero, +)
        let totalWidth = viewsWidth + totalGapSpacing
        let maxHeight = arrangedSubviews.map(\.intrinsicContentSize.height).max() ?? .zero
        return .init(width: totalWidth, height: maxHeight)
    }

    public override func sizeThatFits(_ proposedSize: ProposedSize) -> PreferredSize {
        if let cachedSize = sizeProposalCache[proposedSize] { return cachedSize }
        let totalGapSpacing = arrangedSubviews.hasElements ? spacing * Double(arrangedSubviews.count - 1) : .zero
        var availableWidth = proposedSize.width - totalGapSpacing
        var sizeTable: [UIView: CGSize] = [:]
        let groups = PriorityGroup.grouping(views: arrangedSubviews).sorted { $0.priority > $1.priority }
        for group in groups {
            let availableSize = CGSize(width: availableWidth, height: proposedSize.height)
            let (groupSizeTable, remainingWidth) = fittingSizes(for: group.views, in: availableSize)
            sizeTable.merge(groupSizeTable) { current, new in current } // No duplicate values are expected.
            availableWidth = remainingWidth
        }
        let totalWidth = sizeTable.values.map(\.width).reduce(.zero, +) + totalGapSpacing
        let maxHeight = sizeTable.values.map(\.height).max() ?? .zero
        let size = CGSize(width: totalWidth, height: maxHeight)
        sizeProposalCache[proposedSize] = size
        return size
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard arrangedSubviews.hasElements else { return }
        let totalGapSpacing = arrangedSubviews.hasElements ? spacing * Double(arrangedSubviews.count - 1) : .zero
        var availableWidth = bounds.width - totalGapSpacing
        var globalSizeTable: [UIView: CGSize] = [:]
        let groups = PriorityGroup.grouping(views: arrangedSubviews).sorted { $0.priority > $1.priority }
        for group in groups {
            let availableSize = CGSize(width: availableWidth, height: bounds.height)
            let (localSizeTable, remainingWidth) = fittingSizes(for: group.views, in: availableSize)
            globalSizeTable.merge(localSizeTable) { current, new in current } // No duplicate values are expected.
            availableWidth = remainingWidth
        }
        var leadingOffset = bounds.minX
        for view in arrangedSubviews {
            guard let size = globalSizeTable[view] else { fatalError("Expected a size for view: \(view)") }
            view.frame.origin.x = leadingOffset
            view.frame.origin.y = topOffset(for: .init(size: size), aligned: alignment, within: bounds)
            view.frame.size = size
            leadingOffset += size.width + spacing
        }
    }    
}

extension HStackView {

    private func topOffset(for rect: CGRect, aligned: VerticalAlignment, within bounds: CGRect) -> Double {
        let shift: Double
        switch aligned {
        case .top: shift = .zero
        case .center: shift = (bounds.height - rect.height) / 2
        case .bottom: shift = bounds.height - rect.height
        }
        return bounds.minY + shift
    }

    private func fittingSizes(
        for views: [UIView], in size: CGSize
    ) -> (localSizeTable: [UIView: CGSize], remainingWidth: Double) {
        var localSizeTable: [UIView: CGSize] = [:]

        // The space that remains as views occupy the proposed size.
        var sharedAvailableWidth = size.width

        // The specified array of views, sorted in ascending manner based on their fitting width.
        var widthAscendingViews = views.sorted { $0.sizeThatFits(size).width < $1.sizeThatFits(size).width }

        // When calculating sizes all views start with an equal amount space within the "shared available space".
        // Any remaining space unused by a view is then returned to the "shared available space" for other views to use.
        // In order to ensure no space is wasted in the aforementioned step, the algorithm starts with the thinnest view
        // and works itself towards the widest view.
        while widthAscendingViews.hasElements {
            // An equal amount of space for views yet to be added to the size-table.
            let equallyAllottedWidth = sharedAvailableWidth / Double(widthAscendingViews.count)
            let view = widthAscendingViews.removeFirst()
            var fittingSize = view.sizeThatFits(.init(width: equallyAllottedWidth, height: size.height))
            if view is SpacerView { fittingSize.height = .zero } // FIXME: Avoid Spacer special handling.
            localSizeTable[view] = fittingSize
            sharedAvailableWidth = max(sharedAvailableWidth - fittingSize.width, .zero)
        }
        return (localSizeTable, sharedAvailableWidth)
    }
}
