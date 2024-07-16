//
//  Created by Daniel Inoa on 7/13/24.
//

import UIKit

public final class MutationProxyHook<T>: Hook {

    public let proxy: MutationProxy<T>

    public init(proxy: MutationProxy<T>) {
        self.proxy = proxy
    }

    public func viewWillBeAddedToArrangedTree(_ view: UIView) {
        proxy.setObject(view)
    }
}

public extension Arranged {

    func mutated<T>(by proxy: MutationProxy<T>) -> any Arranged {
        return MutationProxyHook(proxy: proxy).hosted(content: self)
    }
}

import Combine

public final class MutationProxy<W> {

    var objectType: W.Type

    public let subject: CurrentValueSubject<W?, Never> = .init(nil)

    fileprivate(set) public var object: W?
    public init() {
        objectType = W.self
    }

    fileprivate func setObject(_ newObject: Any) {
        if let newObject = newObject as? W {
            object = newObject
        }
    }

    public func mutate(_ forward: (W?) -> Void) {
        forward(object)
        subject.send(object)
    }
}
