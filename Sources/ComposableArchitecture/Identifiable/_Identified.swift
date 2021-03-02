/// A wrapper around a value and a hashable identifier that conforms to _Identifiable.
@dynamicMemberLookup
public struct _Identified<ID, Value>: _Identifiable where ID: Hashable {
  public let id: ID
  public var value: Value

  /// Initializes an _Identified value from a given value and a hashable identifier.
  ///
  /// - Parameters:
  ///   - value: A value.
  ///   - id: A hashable identifier.
  public init(_ value: Value, id: ID) {
    self.id = id
    self.value = value
  }

  /// Initializes an _Identified value from a given value and a function that can return a hashable
  /// identifier from the value.
  ///
  ///     _Identified(uuid, id: \.self)
  ///
  /// - Parameters:
  ///   - value: A value.
  ///   - id: A hashable identifier.
  public init(_ value: Value, id: (Value) -> ID) {
    self.init(value, id: id(value))
  }

  // NB: This overload works around a bug in key path function expressions and `\.self`.
  /// Initializes an _Identified value from a given value and a function that can return a hashable
  /// identifier from the value.
  ///
  ///     _Identified(uuid, id: \.self)
  ///
  /// - Parameters:
  ///   - value: A value.
  ///   - id: A key path from the value to a hashable identifier.
  public init(_ value: Value, id: KeyPath<Value, ID>) {
    self.init(value, id: value[keyPath: id])
  }

  public subscript<LocalValue>(
    dynamicMember keyPath: WritableKeyPath<Value, LocalValue>
  ) -> LocalValue {
    get { self.value[keyPath: keyPath] }
    set { self.value[keyPath: keyPath] = newValue }
  }
}

extension _Identified: Decodable where ID: Decodable, Value: Decodable {}

extension _Identified: Encodable where ID: Encodable, Value: Encodable {}

extension _Identified: Equatable where Value: Equatable {}

extension _Identified: Hashable where Value: Hashable {}
