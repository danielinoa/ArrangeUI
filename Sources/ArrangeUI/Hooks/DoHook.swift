//
//  Created by Daniel Inoa on 7/15/24.
//

import UIKit

final class DoHook<T>: Hook {

    let forward: (T) -> Void

    init(_ closure: @escaping (T) -> Void) {
        self.forward = closure
    }

    func viewWillBeAddedToArrangedTree(_ view: UIView) {
        guard let castedView = view as? T else { return }
        forward(castedView)
    }
}

public extension Arranged {

    func `do`<T: UIView>(_ closure: @escaping (T) -> Void) -> Arranged {
        let hook = DoHook<T>(closure)
        return HookHost.init(arrangedContent: self, hook: hook)
    }
}
