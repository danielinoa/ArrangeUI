//
//  Created by Daniel Inoa on 1/10/24.
//

import Combine

@propertyWrapper
public struct ValueSubject<T> {

    private let currentValueSubject: CurrentValueSubject<T, Never>

    public var projectedValue: CurrentValueSubject<T, Never> {
        currentValueSubject
    }

    public var wrappedValue: T {
        get {
            currentValueSubject.value
        }
        nonmutating set {
            currentValueSubject.value = newValue
        }
    }

    public init(wrappedValue: T) {
        currentValueSubject = .init(wrappedValue)
    }
}
