//
//  Created by Daniel Inoa on 1/26/24.
//

public final class BuilderNode: Arranged {

    public var arrangedContent: Arranged?
    public var subnodes: [BuilderNode]

    public init(content: Arranged, subnodes: [BuilderNode] = []) {
        self.arrangedContent = content
        self.subnodes = subnodes
    }
}
