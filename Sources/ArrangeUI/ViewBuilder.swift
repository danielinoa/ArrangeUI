//
//  Created by Daniel Inoa on 5/19/23.
//

import UIKit

@resultBuilder
public enum ViewBuilder {

    public static func buildBlock(_ components: ViewBuilderComponent...) -> Composite {
        .init(components: components)
    }

    public static func buildEither(first component: Composite) -> Composite {
        component
    }

    public static func buildEither(second component: Composite) -> Composite {
        component
    }

    public static func buildOptional(_ component: Composite?) -> Composite {
        component ?? .init(components: [])
    }

    public struct Composite: ViewBuilderComponent {

        fileprivate let components: [ViewBuilderComponent]

        public func items() -> [ViewBuilderComponent] {
            components.flatMap { component -> [ViewBuilderComponent] in
                guard let builder = component as? Composite else { return [component] }
                return builder.items()
            }
        }
    }
}

public protocol ViewBuilderComponent {}
extension UIView: ViewBuilderComponent {}
