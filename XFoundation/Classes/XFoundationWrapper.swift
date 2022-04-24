import Foundation

public struct XFoundationWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol XFoundationCompatible { }

extension XFoundationCompatible {
    public var x: XFoundationWrapper<Self> {
        get { return XFoundationWrapper(self) }
        set { }
    }
}
