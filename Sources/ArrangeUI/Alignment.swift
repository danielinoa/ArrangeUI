//
//  Created by Daniel Inoa on 5/1/23.
//

public struct Alignment: Equatable {

    // MARK: - Constants

    public static let topLeading: Alignment = .init(horizontal: .leading, vertical: .top)
    public static let top: Alignment = .init(horizontal: .center, vertical: .top)
    public static let topTrailing: Alignment = .init(horizontal: .trailing, vertical: .top)

    public static let leading: Alignment = .init(horizontal: .leading, vertical: .center)
    public static let center: Alignment = .init(horizontal: .center, vertical: .center)
    public static let trailing: Alignment = .init(horizontal: .trailing, vertical: .center)

    public static let bottomLeading: Alignment = .init(horizontal: .leading, vertical: .bottom)
    public static let bottom: Alignment = .init(horizontal: .center, vertical: .bottom)
    public static let bottomTrailing: Alignment = .init(horizontal: .trailing, vertical: .bottom)

    // MARK: - Properties

    public let horizontal: HorizontalAlignment
    public let vertical: VerticalAlignment

    // MARK: - Lifecycle

    public init(horizontal: HorizontalAlignment, vertical: VerticalAlignment) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}

/// The horizontal alignment of items within the stack.
public enum HorizontalAlignment: Equatable {
    // TODO: Add baseline alignment.
    case leading, center, trailing
}

/// The vertical alignment of items within the stack.
public enum VerticalAlignment: Equatable {
    // TODO: Add baseline alignment.
    case top, center, bottom
}
