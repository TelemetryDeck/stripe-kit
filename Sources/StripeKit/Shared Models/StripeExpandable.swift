//
//  StripeExpandable.swift
//
//
//  Created by Andrew Edwards on 4/11/20.
//

import Foundation

extension KeyedDecodingContainer {
    public func decode<U>(_ type: ExpandableCollection<U>.Type, forKey key: Self.Key) throws -> ExpandableCollection<U> where U: Codable {
       return try decodeIfPresent(type, forKey: key) ?? ExpandableCollection<U>()
    }
    
    public func decode<U>(_ type: Expandable<U>.Type, forKey key: Self.Key) throws -> Expandable<U> where U: Codable {
       return try decodeIfPresent(type, forKey: key) ?? Expandable<U>()
    }
    
    public func decode<U,D>(_ type: DynamicExpandable<U,D>.Type, forKey key: Self.Key) throws -> DynamicExpandable<U,D> where U: Codable, D: Codable {
       return try decodeIfPresent(type, forKey: key) ?? DynamicExpandable<U,D>()
    }
}

@propertyWrapper
public struct Expandable<Model: Codable>: Codable, Sendable where Model: Sendable {
    private enum ExpandableState: Sendable {
        case unexpanded(String)
        indirect case expanded(Model)
        case empty
    }

    public init(model: Model) {
        self._state = .expanded(model)
    }

    public init(id: String?) {
        if let id {
            self._state = .unexpanded(id)
        } else {
            self._state = .empty
        }
    }

    public init() {
        self._state = .empty
    }

    public init(from decoder: Decoder) throws {
        if let container = try decoder.singleValueContainerIfPresentAndNotNull() {
            do {
                self._state = try .unexpanded(container.decode(String.self))
            } catch let DecodingError.typeMismatch(type, _) where type is String.Type {
                self._state = try .expanded(container.decode(Model.self))
            }
        } else {
            self._state = .empty
        }
    }

    private var _state: ExpandableState

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch _state {
        case let .unexpanded(id):
            try container.encode(id)
        case let .expanded(model):
            try container.encode(model)
        default:
            try container.encodeNil()
        }
    }

    public var wrappedValue: String? {
        switch _state {
        case let .unexpanded(id):
            return id
        case .expanded(_), .empty:
            return nil
        }
    }

    public var projectedValue: Model? {
        switch _state {
        case .unexpanded(_), .empty:
            return nil
        case let .expanded(model):
            return model
        }
    }
}

@propertyWrapper
public struct DynamicExpandable<A: Codable, B: Codable>: Codable, Sendable where A: Sendable, B: Sendable {
    private enum ExpandableState: @unchecked Sendable {
        case unexpanded(String)
        indirect case expanded(Codable)
        case empty
    }

    public init(model: A) {
        self._state = .expanded(model)
    }

    public init(model: B) {
        self._state = .expanded(model)
    }

    public init(id: String?) {
        if let id {
            self._state = .unexpanded(id)
        } else {
            self._state = .empty
        }
    }

    public init() {
        self._state = .empty
    }

    public init(from decoder: Decoder) throws {
        let codingPath = decoder.codingPath
        do {
            let container = try decoder.singleValueContainer()
            do {
                if container.decodeNil() {
                    self._state = .empty
                } else {
                    self._state = try .unexpanded(container.decode(String.self))
                }
            } catch let DecodingError.typeMismatch(type, _) where type is String.Type {
                do {
                    self._state = try .expanded(container.decode(A.self))
                } catch { // can't catch a specific error here, any particular B might partially decode as A
                    self._state = try .expanded(container.decode(B.self))
                }
            }
        } catch let DecodingError.keyNotFound(_, context) where context.codingPath.count == codingPath.count {
            self._state = .empty
        }
    }

    private var _state: ExpandableState

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch _state {
        case let .unexpanded(id):
            try container.encode(id)
        case let .expanded(model):
            if let a = model as? A {
                try container.encode(a)
            } else if let b = model as? B {
                try container.encode(b)
            } else {
                preconditionFailure("Invalid model storage")
            }
        default:
            try container.encodeNil()
        }
    }

    public var wrappedValue: String? {
        switch _state {
        case let .unexpanded(id):
            return id
        case .expanded(_), .empty:
            return nil
        }
    }

    public var projectedValue: DynamicExpandable<A, B> { self }

    public func callAsFunction<T: Codable>(as type: T.Type) -> T? {
        switch _state {
        case .unexpanded(_), .empty:
            return nil
        case let .expanded(model):
            if let model = model as? T {
                return model
            } else {
                return nil
            }
        }
    }
}

@propertyWrapper
public struct ExpandableCollection<Model: Codable>: Codable, Sendable where Model: Sendable {
    private enum ExpandableState: Sendable {
        case unexpanded([String])
        indirect case expanded([Model])
        case empty
    }

    public init() {
        self._state = .empty
    }

    public init(ids: [String]?) {
        if let ids {
            self._state = .unexpanded(ids)
        } else {
            self._state = .empty
        }
    }

    public init(models: [Model]?) {
        if let models {
            self._state = .expanded(models)
        } else {
            self._state = .empty
        }
    }

    public init(from decoder: Decoder) throws {
        if let container = try decoder.singleValueContainerIfPresentAndNotNull() {
            do {
                self._state = try .unexpanded(container.decode([String].self))
            } catch let DecodingError.typeMismatch(type, _) where type is String.Type {
                self._state = try .expanded(container.decode([Model].self))
            }
        } else {
            self._state = .empty
        }
    }

    private var _state: ExpandableState

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch _state {
        case let .unexpanded(ids):
            try container.encode(ids)
        case let .expanded(models):
            try container.encode(models)
        default:
            try container.encodeNil()
        }
    }

    public var wrappedValue: [String]? {
        switch _state {
        case let .unexpanded(ids):
            return ids
        case .expanded(_), .empty:
            return nil
        }
    }

    public var projectedValue: [Model]? {
        switch _state {
        case .unexpanded(_), .empty:
            return nil
        case let .expanded(models):
            return models
        }
    }
}

extension Decoder {
    func singleValueContainerIfPresentAndNotNull() throws -> SingleValueDecodingContainer? {
        do {
            let container = try singleValueContainer()

            if container.decodeNil() {
                return nil
            }
            return container
        } catch let DecodingError.keyNotFound(_, context)
            where context.codingPath.count == codingPath.count
        {
            return nil
        }
    }
}
