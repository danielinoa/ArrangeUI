//
//  Created by Daniel Inoa on 3/3/24.
//

@resultBuilder
public enum ArrangedResultBuilder {

    public static func buildBlock(_ components: Arranged...) -> [Arranged] {
        components
    }
}
