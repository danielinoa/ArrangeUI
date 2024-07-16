//
//  Created by Daniel Inoa on 7/15/24.
//

import UIKit

final class HookHost: Arranged {

    var arrangedContent: (any Arranged)?
    var hook: Hook

    init(arrangedContent: (any Arranged)?, hook: Hook) {
        self.arrangedContent = arrangedContent
        self.hook = hook
    }

    func process(_ view: UIView) {
        hook.viewWillBeAddedToArrangedTree(view)
    }
}

extension Hook {

    func hosted(content: Arranged) -> Arranged {
        HookHost(arrangedContent: content, hook: self)
    }
}
