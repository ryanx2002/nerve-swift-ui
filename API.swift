//  This file was automatically generated and should not be edited.

#if canImport(AWSAPIPlugin)
import Foundation

public protocol GraphQLInputValue {
}

public struct GraphQLVariable {
  let name: String
  
  public init(_ name: String) {
    self.name = name
  }
}

extension GraphQLVariable: GraphQLInputValue {
}

extension JSONEncodable {
  public func evaluate(with variables: [String: JSONEncodable]?) throws -> Any {
    return jsonValue
  }
}

public typealias GraphQLMap = [String: JSONEncodable?]

extension Dictionary where Key == String, Value == JSONEncodable? {
  public var withNilValuesRemoved: Dictionary<String, JSONEncodable> {
    var filtered = Dictionary<String, JSONEncodable>(minimumCapacity: count)
    for (key, value) in self {
      if value != nil {
        filtered[key] = value
      }
    }
    return filtered
  }
}

public protocol GraphQLMapConvertible: JSONEncodable {
  var graphQLMap: GraphQLMap { get }
}

public extension GraphQLMapConvertible {
  var jsonValue: Any {
    return graphQLMap.withNilValuesRemoved.jsonValue
  }
}

public typealias GraphQLID = String

public protocol APISwiftGraphQLOperation: AnyObject {
  
  static var operationString: String { get }
  static var requestString: String { get }
  static var operationIdentifier: String? { get }
  
  var variables: GraphQLMap? { get }
  
  associatedtype Data: GraphQLSelectionSet
}

public extension APISwiftGraphQLOperation {
  static var requestString: String {
    return operationString
  }

  static var operationIdentifier: String? {
    return nil
  }

  var variables: GraphQLMap? {
    return nil
  }
}

public protocol GraphQLQuery: APISwiftGraphQLOperation {}

public protocol GraphQLMutation: APISwiftGraphQLOperation {}

public protocol GraphQLSubscription: APISwiftGraphQLOperation {}

public protocol GraphQLFragment: GraphQLSelectionSet {
  static var possibleTypes: [String] { get }
}

public typealias Snapshot = [String: Any?]

public protocol GraphQLSelectionSet: Decodable {
  static var selections: [GraphQLSelection] { get }
  
  var snapshot: Snapshot { get }
  init(snapshot: Snapshot)
}

extension GraphQLSelectionSet {
    public init(from decoder: Decoder) throws {
        if let jsonObject = try? APISwiftJSONValue(from: decoder) {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(jsonObject)
            let decodedDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            let optionalDictionary = decodedDictionary.mapValues { $0 as Any? }

            self.init(snapshot: optionalDictionary)
        } else {
            self.init(snapshot: [:])
        }
    }
}

enum APISwiftJSONValue: Codable {
    case array([APISwiftJSONValue])
    case boolean(Bool)
    case number(Double)
    case object([String: APISwiftJSONValue])
    case string(String)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode([String: APISwiftJSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([APISwiftJSONValue].self) {
            self = .array(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .boolean(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else {
            self = .null
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .array(let value):
            try container.encode(value)
        case .boolean(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

public protocol GraphQLSelection {
}

public struct GraphQLField: GraphQLSelection {
  let name: String
  let alias: String?
  let arguments: [String: GraphQLInputValue]?
  
  var responseKey: String {
    return alias ?? name
  }
  
  let type: GraphQLOutputType
  
  public init(_ name: String, alias: String? = nil, arguments: [String: GraphQLInputValue]? = nil, type: GraphQLOutputType) {
    self.name = name
    self.alias = alias
    
    self.arguments = arguments
    
    self.type = type
  }
}

public indirect enum GraphQLOutputType {
  case scalar(JSONDecodable.Type)
  case object([GraphQLSelection])
  case nonNull(GraphQLOutputType)
  case list(GraphQLOutputType)
  
  var namedType: GraphQLOutputType {
    switch self {
    case .nonNull(let innerType), .list(let innerType):
      return innerType.namedType
    case .scalar, .object:
      return self
    }
  }
}

public struct GraphQLBooleanCondition: GraphQLSelection {
  let variableName: String
  let inverted: Bool
  let selections: [GraphQLSelection]
  
  public init(variableName: String, inverted: Bool, selections: [GraphQLSelection]) {
    self.variableName = variableName
    self.inverted = inverted;
    self.selections = selections;
  }
}

public struct GraphQLTypeCondition: GraphQLSelection {
  let possibleTypes: [String]
  let selections: [GraphQLSelection]
  
  public init(possibleTypes: [String], selections: [GraphQLSelection]) {
    self.possibleTypes = possibleTypes
    self.selections = selections;
  }
}

public struct GraphQLFragmentSpread: GraphQLSelection {
  let fragment: GraphQLFragment.Type
  
  public init(_ fragment: GraphQLFragment.Type) {
    self.fragment = fragment
  }
}

public struct GraphQLTypeCase: GraphQLSelection {
  let variants: [String: [GraphQLSelection]]
  let `default`: [GraphQLSelection]
  
  public init(variants: [String: [GraphQLSelection]], default: [GraphQLSelection]) {
    self.variants = variants
    self.default = `default`;
  }
}

public typealias JSONObject = [String: Any]

public protocol JSONDecodable {
  init(jsonValue value: Any) throws
}

public protocol JSONEncodable: GraphQLInputValue {
  var jsonValue: Any { get }
}

public enum JSONDecodingError: Error, LocalizedError {
  case missingValue
  case nullValue
  case wrongType
  case couldNotConvert(value: Any, to: Any.Type)
  
  public var errorDescription: String? {
    switch self {
    case .missingValue:
      return "Missing value"
    case .nullValue:
      return "Unexpected null value"
    case .wrongType:
      return "Wrong type"
    case .couldNotConvert(let value, let expectedType):
      return "Could not convert \"\(value)\" to \(expectedType)"
    }
  }
}

extension String: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
    }
    self = string
  }

  public var jsonValue: Any {
    return self
  }
}

extension Int: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Int.self)
    }
    self = number.intValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Float: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Float.self)
    }
    self = number.floatValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Double: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Double.self)
    }
    self = number.doubleValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Bool: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let bool = value as? Bool else {
        throw JSONDecodingError.couldNotConvert(value: value, to: Bool.self)
    }
    self = bool
  }

  public var jsonValue: Any {
    return self
  }
}

extension RawRepresentable where RawValue: JSONDecodable {
  public init(jsonValue value: Any) throws {
    let rawValue = try RawValue(jsonValue: value)
    if let tempSelf = Self(rawValue: rawValue) {
      self = tempSelf
    } else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Self.self)
    }
  }
}

extension RawRepresentable where RawValue: JSONEncodable {
  public var jsonValue: Any {
    return rawValue.jsonValue
  }
}

extension Optional where Wrapped: JSONDecodable {
  public init(jsonValue value: Any) throws {
    if value is NSNull {
      self = .none
    } else {
      self = .some(try Wrapped(jsonValue: value))
    }
  }
}

extension Optional: JSONEncodable {
  public var jsonValue: Any {
    switch self {
    case .none:
      return NSNull()
    case .some(let wrapped as JSONEncodable):
      return wrapped.jsonValue
    default:
      fatalError("Optional is only JSONEncodable if Wrapped is")
    }
  }
}

extension Dictionary: JSONEncodable {
  public var jsonValue: Any {
    return jsonObject
  }
  
  public var jsonObject: JSONObject {
    var jsonObject = JSONObject(minimumCapacity: count)
    for (key, value) in self {
      if case let (key as String, value as JSONEncodable) = (key, value) {
        jsonObject[key] = value.jsonValue
      } else {
        fatalError("Dictionary is only JSONEncodable if Value is (and if Key is String)")
      }
    }
    return jsonObject
  }
}

extension Array: JSONEncodable {
  public var jsonValue: Any {
    return map() { element -> (Any) in
      if case let element as JSONEncodable = element {
        return element.jsonValue
      } else {
        fatalError("Array is only JSONEncodable if Element is")
      }
    }
  }
}

extension URL: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: URL.self)
    }
    self.init(string: string)!
  }

  public var jsonValue: Any {
    return self.absoluteString
  }
}

extension Dictionary {
  static func += (lhs: inout Dictionary, rhs: Dictionary) {
    lhs.merge(rhs) { (_, new) in new }
  }
}

#elseif canImport(AWSAppSync)
import AWSAppSync
#endif

public struct CreateDareInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, title: String, description: String? = nil) {
    graphQLMap = ["id": id, "title": title, "description": description]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var title: String {
    get {
      return graphQLMap["title"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var description: String? {
    get {
      return graphQLMap["description"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }
}

public struct ModelDareConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(title: ModelStringInput? = nil, description: ModelStringInput? = nil, and: [ModelDareConditionInput?]? = nil, or: [ModelDareConditionInput?]? = nil, not: ModelDareConditionInput? = nil) {
    graphQLMap = ["title": title, "description": description, "and": and, "or": or, "not": not]
  }

  public var title: ModelStringInput? {
    get {
      return graphQLMap["title"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var description: ModelStringInput? {
    get {
      return graphQLMap["description"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var and: [ModelDareConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelDareConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelDareConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelDareConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelDareConditionInput? {
    get {
      return graphQLMap["not"] as! ModelDareConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public enum ModelAttributeTypes: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case binary
  case binarySet
  case bool
  case list
  case map
  case number
  case numberSet
  case string
  case stringSet
  case null
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "binary": self = .binary
      case "binarySet": self = .binarySet
      case "bool": self = .bool
      case "list": self = .list
      case "map": self = .map
      case "number": self = .number
      case "numberSet": self = .numberSet
      case "string": self = .string
      case "stringSet": self = .stringSet
      case "_null": self = .null
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .binary: return "binary"
      case .binarySet: return "binarySet"
      case .bool: return "bool"
      case .list: return "list"
      case .map: return "map"
      case .number: return "number"
      case .numberSet: return "numberSet"
      case .string: return "string"
      case .stringSet: return "stringSet"
      case .null: return "_null"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ModelAttributeTypes, rhs: ModelAttributeTypes) -> Bool {
    switch (lhs, rhs) {
      case (.binary, .binary): return true
      case (.binarySet, .binarySet): return true
      case (.bool, .bool): return true
      case (.list, .list): return true
      case (.map, .map): return true
      case (.number, .number): return true
      case (.numberSet, .numberSet): return true
      case (.string, .string): return true
      case (.stringSet, .stringSet): return true
      case (.null, .null): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelSizeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }
}

public struct UpdateDareInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, title: String? = nil, description: String? = nil) {
    graphQLMap = ["id": id, "title": title, "description": description]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var title: String? {
    get {
      return graphQLMap["title"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var description: String? {
    get {
      return graphQLMap["description"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }
}

public struct DeleteDareInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, name: String, phoneNumber: String, venmo: String? = nil) {
    graphQLMap = ["id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var phoneNumber: String {
    get {
      return graphQLMap["phoneNumber"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  public var venmo: String? {
    get {
      return graphQLMap["venmo"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "venmo")
    }
  }
}

public struct ModelUserConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: ModelStringInput? = nil, phoneNumber: ModelStringInput? = nil, venmo: ModelStringInput? = nil, and: [ModelUserConditionInput?]? = nil, or: [ModelUserConditionInput?]? = nil, not: ModelUserConditionInput? = nil) {
    graphQLMap = ["name": name, "phoneNumber": phoneNumber, "venmo": venmo, "and": and, "or": or, "not": not]
  }

  public var name: ModelStringInput? {
    get {
      return graphQLMap["name"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var phoneNumber: ModelStringInput? {
    get {
      return graphQLMap["phoneNumber"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  public var venmo: ModelStringInput? {
    get {
      return graphQLMap["venmo"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "venmo")
    }
  }

  public var and: [ModelUserConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelUserConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelUserConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelUserConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelUserConditionInput? {
    get {
      return graphQLMap["not"] as! ModelUserConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct UpdateUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, name: String? = nil, phoneNumber: String? = nil, venmo: String? = nil) {
    graphQLMap = ["id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return graphQLMap["name"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var phoneNumber: String? {
    get {
      return graphQLMap["phoneNumber"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  public var venmo: String? {
    get {
      return graphQLMap["venmo"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "venmo")
    }
  }
}

public struct DeleteUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateVideoInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, viewCount: Int? = nil, videoUrl: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "viewCount": viewCount, "videoURL": videoUrl, "dareVideosId": dareVideosId, "userVideosId": userVideosId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var viewCount: Int? {
    get {
      return graphQLMap["viewCount"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "viewCount")
    }
  }

  public var videoUrl: String {
    get {
      return graphQLMap["videoURL"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoURL")
    }
  }

  public var dareVideosId: GraphQLID? {
    get {
      return graphQLMap["dareVideosId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dareVideosId")
    }
  }

  public var userVideosId: GraphQLID? {
    get {
      return graphQLMap["userVideosId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userVideosId")
    }
  }
}

public struct ModelVideoConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(viewCount: ModelIntInput? = nil, videoUrl: ModelStringInput? = nil, and: [ModelVideoConditionInput?]? = nil, or: [ModelVideoConditionInput?]? = nil, not: ModelVideoConditionInput? = nil, dareVideosId: ModelIDInput? = nil, userVideosId: ModelIDInput? = nil) {
    graphQLMap = ["viewCount": viewCount, "videoURL": videoUrl, "and": and, "or": or, "not": not, "dareVideosId": dareVideosId, "userVideosId": userVideosId]
  }

  public var viewCount: ModelIntInput? {
    get {
      return graphQLMap["viewCount"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "viewCount")
    }
  }

  public var videoUrl: ModelStringInput? {
    get {
      return graphQLMap["videoURL"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoURL")
    }
  }

  public var and: [ModelVideoConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelVideoConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelVideoConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelVideoConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelVideoConditionInput? {
    get {
      return graphQLMap["not"] as! ModelVideoConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var dareVideosId: ModelIDInput? {
    get {
      return graphQLMap["dareVideosId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dareVideosId")
    }
  }

  public var userVideosId: ModelIDInput? {
    get {
      return graphQLMap["userVideosId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userVideosId")
    }
  }
}

public struct ModelIntInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between, "attributeExists": attributeExists, "attributeType": attributeType]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }
}

public struct ModelIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public struct UpdateVideoInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String? = nil, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "viewCount": viewCount, "videoURL": videoUrl, "dareVideosId": dareVideosId, "userVideosId": userVideosId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var viewCount: Int? {
    get {
      return graphQLMap["viewCount"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "viewCount")
    }
  }

  public var videoUrl: String? {
    get {
      return graphQLMap["videoURL"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoURL")
    }
  }

  public var dareVideosId: GraphQLID? {
    get {
      return graphQLMap["dareVideosId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dareVideosId")
    }
  }

  public var userVideosId: GraphQLID? {
    get {
      return graphQLMap["userVideosId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userVideosId")
    }
  }
}

public struct DeleteVideoInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct ModelDareFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, title: ModelStringInput? = nil, description: ModelStringInput? = nil, and: [ModelDareFilterInput?]? = nil, or: [ModelDareFilterInput?]? = nil, not: ModelDareFilterInput? = nil) {
    graphQLMap = ["id": id, "title": title, "description": description, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var title: ModelStringInput? {
    get {
      return graphQLMap["title"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var description: ModelStringInput? {
    get {
      return graphQLMap["description"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var and: [ModelDareFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelDareFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelDareFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelDareFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelDareFilterInput? {
    get {
      return graphQLMap["not"] as! ModelDareFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelUserFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, name: ModelStringInput? = nil, phoneNumber: ModelStringInput? = nil, venmo: ModelStringInput? = nil, and: [ModelUserFilterInput?]? = nil, or: [ModelUserFilterInput?]? = nil, not: ModelUserFilterInput? = nil) {
    graphQLMap = ["id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: ModelStringInput? {
    get {
      return graphQLMap["name"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var phoneNumber: ModelStringInput? {
    get {
      return graphQLMap["phoneNumber"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  public var venmo: ModelStringInput? {
    get {
      return graphQLMap["venmo"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "venmo")
    }
  }

  public var and: [ModelUserFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelUserFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelUserFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelUserFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelUserFilterInput? {
    get {
      return graphQLMap["not"] as! ModelUserFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelVideoFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, viewCount: ModelIntInput? = nil, videoUrl: ModelStringInput? = nil, and: [ModelVideoFilterInput?]? = nil, or: [ModelVideoFilterInput?]? = nil, not: ModelVideoFilterInput? = nil, dareVideosId: ModelIDInput? = nil, userVideosId: ModelIDInput? = nil) {
    graphQLMap = ["id": id, "viewCount": viewCount, "videoURL": videoUrl, "and": and, "or": or, "not": not, "dareVideosId": dareVideosId, "userVideosId": userVideosId]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var viewCount: ModelIntInput? {
    get {
      return graphQLMap["viewCount"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "viewCount")
    }
  }

  public var videoUrl: ModelStringInput? {
    get {
      return graphQLMap["videoURL"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoURL")
    }
  }

  public var and: [ModelVideoFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelVideoFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelVideoFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelVideoFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelVideoFilterInput? {
    get {
      return graphQLMap["not"] as! ModelVideoFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var dareVideosId: ModelIDInput? {
    get {
      return graphQLMap["dareVideosId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dareVideosId")
    }
  }

  public var userVideosId: ModelIDInput? {
    get {
      return graphQLMap["userVideosId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userVideosId")
    }
  }
}

public struct ModelSubscriptionDareFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, title: ModelSubscriptionStringInput? = nil, description: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionDareFilterInput?]? = nil, or: [ModelSubscriptionDareFilterInput?]? = nil) {
    graphQLMap = ["id": id, "title": title, "description": description, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var title: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["title"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var description: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["description"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var and: [ModelSubscriptionDareFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionDareFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionDareFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionDareFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [GraphQLID?]? {
    get {
      return graphQLMap["in"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [GraphQLID?]? {
    get {
      return graphQLMap["notIn"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [String?]? {
    get {
      return graphQLMap["in"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [String?]? {
    get {
      return graphQLMap["notIn"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionUserFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, name: ModelSubscriptionStringInput? = nil, phoneNumber: ModelSubscriptionStringInput? = nil, venmo: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionUserFilterInput?]? = nil, or: [ModelSubscriptionUserFilterInput?]? = nil) {
    graphQLMap = ["id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["name"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var phoneNumber: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["phoneNumber"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  public var venmo: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["venmo"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "venmo")
    }
  }

  public var and: [ModelSubscriptionUserFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionUserFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionUserFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionUserFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionVideoFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, viewCount: ModelSubscriptionIntInput? = nil, videoUrl: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionVideoFilterInput?]? = nil, or: [ModelSubscriptionVideoFilterInput?]? = nil) {
    graphQLMap = ["id": id, "viewCount": viewCount, "videoURL": videoUrl, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var viewCount: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["viewCount"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "viewCount")
    }
  }

  public var videoUrl: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["videoURL"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoURL")
    }
  }

  public var and: [ModelSubscriptionVideoFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionVideoFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionVideoFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionVideoFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionIntInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil, `in`: [Int?]? = nil, notIn: [Int?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between, "in": `in`, "notIn": notIn]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var `in`: [Int?]? {
    get {
      return graphQLMap["in"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [Int?]? {
    get {
      return graphQLMap["notIn"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public final class CreateDareMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateDare($input: CreateDareInput!, $condition: ModelDareConditionInput) {\n  createDare(input: $input, condition: $condition) {\n    __typename\n    id\n    title\n    description\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateDareInput
  public var condition: ModelDareConditionInput?

  public init(input: CreateDareInput, condition: ModelDareConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createDare", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateDare.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createDare: CreateDare? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createDare": createDare.flatMap { $0.snapshot }])
    }

    public var createDare: CreateDare? {
      get {
        return (snapshot["createDare"] as? Snapshot).flatMap { CreateDare(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createDare")
      }
    }

    public struct CreateDare: GraphQLSelectionSet {
      public static let possibleTypes = ["Dare"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class UpdateDareMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateDare($input: UpdateDareInput!, $condition: ModelDareConditionInput) {\n  updateDare(input: $input, condition: $condition) {\n    __typename\n    id\n    title\n    description\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateDareInput
  public var condition: ModelDareConditionInput?

  public init(input: UpdateDareInput, condition: ModelDareConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateDare", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateDare.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateDare: UpdateDare? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateDare": updateDare.flatMap { $0.snapshot }])
    }

    public var updateDare: UpdateDare? {
      get {
        return (snapshot["updateDare"] as? Snapshot).flatMap { UpdateDare(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateDare")
      }
    }

    public struct UpdateDare: GraphQLSelectionSet {
      public static let possibleTypes = ["Dare"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class DeleteDareMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteDare($input: DeleteDareInput!, $condition: ModelDareConditionInput) {\n  deleteDare(input: $input, condition: $condition) {\n    __typename\n    id\n    title\n    description\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteDareInput
  public var condition: ModelDareConditionInput?

  public init(input: DeleteDareInput, condition: ModelDareConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteDare", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteDare.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteDare: DeleteDare? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteDare": deleteDare.flatMap { $0.snapshot }])
    }

    public var deleteDare: DeleteDare? {
      get {
        return (snapshot["deleteDare"] as? Snapshot).flatMap { DeleteDare(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteDare")
      }
    }

    public struct DeleteDare: GraphQLSelectionSet {
      public static let possibleTypes = ["Dare"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class CreateUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateUser($input: CreateUserInput!, $condition: ModelUserConditionInput) {\n  createUser(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    phoneNumber\n    venmo\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n    owner\n  }\n}"

  public var input: CreateUserInput
  public var condition: ModelUserConditionInput?

  public init(input: CreateUserInput, condition: ModelUserConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createUser", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createUser: CreateUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createUser": createUser.flatMap { $0.snapshot }])
    }

    public var createUser: CreateUser? {
      get {
        return (snapshot["createUser"] as? Snapshot).flatMap { CreateUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createUser")
      }
    }

    public struct CreateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("venmo", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var venmo: String? {
        get {
          return snapshot["venmo"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "venmo")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class UpdateUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateUser($input: UpdateUserInput!, $condition: ModelUserConditionInput) {\n  updateUser(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    phoneNumber\n    venmo\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n    owner\n  }\n}"

  public var input: UpdateUserInput
  public var condition: ModelUserConditionInput?

  public init(input: UpdateUserInput, condition: ModelUserConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateUser", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateUser: UpdateUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateUser": updateUser.flatMap { $0.snapshot }])
    }

    public var updateUser: UpdateUser? {
      get {
        return (snapshot["updateUser"] as? Snapshot).flatMap { UpdateUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateUser")
      }
    }

    public struct UpdateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("venmo", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var venmo: String? {
        get {
          return snapshot["venmo"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "venmo")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class DeleteUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteUser($input: DeleteUserInput!, $condition: ModelUserConditionInput) {\n  deleteUser(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    phoneNumber\n    venmo\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n    owner\n  }\n}"

  public var input: DeleteUserInput
  public var condition: ModelUserConditionInput?

  public init(input: DeleteUserInput, condition: ModelUserConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteUser", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteUser: DeleteUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteUser": deleteUser.flatMap { $0.snapshot }])
    }

    public var deleteUser: DeleteUser? {
      get {
        return (snapshot["deleteUser"] as? Snapshot).flatMap { DeleteUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteUser")
      }
    }

    public struct DeleteUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("venmo", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var venmo: String? {
        get {
          return snapshot["venmo"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "venmo")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class CreateVideoMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateVideo($input: CreateVideoInput!, $condition: ModelVideoConditionInput) {\n  createVideo(input: $input, condition: $condition) {\n    __typename\n    id\n    viewCount\n    videoURL\n    dare {\n      __typename\n      id\n      title\n      description\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n    }\n    user {\n      __typename\n      id\n      name\n      phoneNumber\n      venmo\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n      owner\n    }\n    createdAt\n    updatedAt\n    dareVideosId\n    userVideosId\n    owner\n  }\n}"

  public var input: CreateVideoInput
  public var condition: ModelVideoConditionInput?

  public init(input: CreateVideoInput, condition: ModelVideoConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createVideo", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createVideo: CreateVideo? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createVideo": createVideo.flatMap { $0.snapshot }])
    }

    public var createVideo: CreateVideo? {
      get {
        return (snapshot["createVideo"] as? Snapshot).flatMap { CreateVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createVideo")
      }
    }

    public struct CreateVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("viewCount", type: .scalar(Int.self)),
        GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
        GraphQLField("dare", type: .object(Dare.selections)),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, dare: Dare? = nil, user: User? = nil, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
        self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "dare": dare.flatMap { $0.snapshot }, "user": user.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var viewCount: Int? {
        get {
          return snapshot["viewCount"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "viewCount")
        }
      }

      public var videoUrl: String {
        get {
          return snapshot["videoURL"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoURL")
        }
      }

      public var dare: Dare? {
        get {
          return (snapshot["dare"] as? Snapshot).flatMap { Dare(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "dare")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var dareVideosId: GraphQLID? {
        get {
          return snapshot["dareVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dareVideosId")
        }
      }

      public var userVideosId: GraphQLID? {
        get {
          return snapshot["userVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userVideosId")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Dare: GraphQLSelectionSet {
        public static let possibleTypes = ["Dare"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var description: String? {
          get {
            return snapshot["description"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
          GraphQLField("venmo", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("owner", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var phoneNumber: String {
          get {
            return snapshot["phoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var venmo: String? {
          get {
            return snapshot["venmo"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "venmo")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var owner: String? {
          get {
            return snapshot["owner"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class UpdateVideoMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateVideo($input: UpdateVideoInput!, $condition: ModelVideoConditionInput) {\n  updateVideo(input: $input, condition: $condition) {\n    __typename\n    id\n    viewCount\n    videoURL\n    dare {\n      __typename\n      id\n      title\n      description\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n    }\n    user {\n      __typename\n      id\n      name\n      phoneNumber\n      venmo\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n      owner\n    }\n    createdAt\n    updatedAt\n    dareVideosId\n    userVideosId\n    owner\n  }\n}"

  public var input: UpdateVideoInput
  public var condition: ModelVideoConditionInput?

  public init(input: UpdateVideoInput, condition: ModelVideoConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateVideo", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateVideo: UpdateVideo? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateVideo": updateVideo.flatMap { $0.snapshot }])
    }

    public var updateVideo: UpdateVideo? {
      get {
        return (snapshot["updateVideo"] as? Snapshot).flatMap { UpdateVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateVideo")
      }
    }

    public struct UpdateVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("viewCount", type: .scalar(Int.self)),
        GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
        GraphQLField("dare", type: .object(Dare.selections)),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, dare: Dare? = nil, user: User? = nil, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
        self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "dare": dare.flatMap { $0.snapshot }, "user": user.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var viewCount: Int? {
        get {
          return snapshot["viewCount"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "viewCount")
        }
      }

      public var videoUrl: String {
        get {
          return snapshot["videoURL"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoURL")
        }
      }

      public var dare: Dare? {
        get {
          return (snapshot["dare"] as? Snapshot).flatMap { Dare(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "dare")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var dareVideosId: GraphQLID? {
        get {
          return snapshot["dareVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dareVideosId")
        }
      }

      public var userVideosId: GraphQLID? {
        get {
          return snapshot["userVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userVideosId")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Dare: GraphQLSelectionSet {
        public static let possibleTypes = ["Dare"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var description: String? {
          get {
            return snapshot["description"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
          GraphQLField("venmo", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("owner", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var phoneNumber: String {
          get {
            return snapshot["phoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var venmo: String? {
          get {
            return snapshot["venmo"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "venmo")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var owner: String? {
          get {
            return snapshot["owner"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class DeleteVideoMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteVideo($input: DeleteVideoInput!, $condition: ModelVideoConditionInput) {\n  deleteVideo(input: $input, condition: $condition) {\n    __typename\n    id\n    viewCount\n    videoURL\n    dare {\n      __typename\n      id\n      title\n      description\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n    }\n    user {\n      __typename\n      id\n      name\n      phoneNumber\n      venmo\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n      owner\n    }\n    createdAt\n    updatedAt\n    dareVideosId\n    userVideosId\n    owner\n  }\n}"

  public var input: DeleteVideoInput
  public var condition: ModelVideoConditionInput?

  public init(input: DeleteVideoInput, condition: ModelVideoConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteVideo", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteVideo: DeleteVideo? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteVideo": deleteVideo.flatMap { $0.snapshot }])
    }

    public var deleteVideo: DeleteVideo? {
      get {
        return (snapshot["deleteVideo"] as? Snapshot).flatMap { DeleteVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteVideo")
      }
    }

    public struct DeleteVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("viewCount", type: .scalar(Int.self)),
        GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
        GraphQLField("dare", type: .object(Dare.selections)),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, dare: Dare? = nil, user: User? = nil, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
        self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "dare": dare.flatMap { $0.snapshot }, "user": user.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var viewCount: Int? {
        get {
          return snapshot["viewCount"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "viewCount")
        }
      }

      public var videoUrl: String {
        get {
          return snapshot["videoURL"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoURL")
        }
      }

      public var dare: Dare? {
        get {
          return (snapshot["dare"] as? Snapshot).flatMap { Dare(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "dare")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var dareVideosId: GraphQLID? {
        get {
          return snapshot["dareVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dareVideosId")
        }
      }

      public var userVideosId: GraphQLID? {
        get {
          return snapshot["userVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userVideosId")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Dare: GraphQLSelectionSet {
        public static let possibleTypes = ["Dare"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var description: String? {
          get {
            return snapshot["description"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
          GraphQLField("venmo", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("owner", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var phoneNumber: String {
          get {
            return snapshot["phoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var venmo: String? {
          get {
            return snapshot["venmo"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "venmo")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var owner: String? {
          get {
            return snapshot["owner"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class GetDareQuery: GraphQLQuery {
  public static let operationString =
    "query GetDare($id: ID!) {\n  getDare(id: $id) {\n    __typename\n    id\n    title\n    description\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getDare", arguments: ["id": GraphQLVariable("id")], type: .object(GetDare.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getDare: GetDare? = nil) {
      self.init(snapshot: ["__typename": "Query", "getDare": getDare.flatMap { $0.snapshot }])
    }

    public var getDare: GetDare? {
      get {
        return (snapshot["getDare"] as? Snapshot).flatMap { GetDare(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getDare")
      }
    }

    public struct GetDare: GraphQLSelectionSet {
      public static let possibleTypes = ["Dare"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class ListDaresQuery: GraphQLQuery {
  public static let operationString =
    "query ListDares($filter: ModelDareFilterInput, $limit: Int, $nextToken: String) {\n  listDares(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      title\n      description\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelDareFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelDareFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listDares", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListDare.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listDares: ListDare? = nil) {
      self.init(snapshot: ["__typename": "Query", "listDares": listDares.flatMap { $0.snapshot }])
    }

    public var listDares: ListDare? {
      get {
        return (snapshot["listDares"] as? Snapshot).flatMap { ListDare(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listDares")
      }
    }

    public struct ListDare: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelDareConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelDareConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Dare"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var description: String? {
          get {
            return snapshot["description"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class GetUserQuery: GraphQLQuery {
  public static let operationString =
    "query GetUser($id: ID!) {\n  getUser(id: $id) {\n    __typename\n    id\n    name\n    phoneNumber\n    venmo\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n    owner\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getUser", arguments: ["id": GraphQLVariable("id")], type: .object(GetUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getUser: GetUser? = nil) {
      self.init(snapshot: ["__typename": "Query", "getUser": getUser.flatMap { $0.snapshot }])
    }

    public var getUser: GetUser? {
      get {
        return (snapshot["getUser"] as? Snapshot).flatMap { GetUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getUser")
      }
    }

    public struct GetUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("venmo", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var venmo: String? {
        get {
          return snapshot["venmo"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "venmo")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class ListUsersQuery: GraphQLQuery {
  public static let operationString =
    "query ListUsers($filter: ModelUserFilterInput, $limit: Int, $nextToken: String) {\n  listUsers(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      name\n      phoneNumber\n      venmo\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n      owner\n    }\n    nextToken\n  }\n}"

  public var filter: ModelUserFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelUserFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listUsers", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listUsers: ListUser? = nil) {
      self.init(snapshot: ["__typename": "Query", "listUsers": listUsers.flatMap { $0.snapshot }])
    }

    public var listUsers: ListUser? {
      get {
        return (snapshot["listUsers"] as? Snapshot).flatMap { ListUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listUsers")
      }
    }

    public struct ListUser: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelUserConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelUserConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
          GraphQLField("venmo", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("owner", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var phoneNumber: String {
          get {
            return snapshot["phoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var venmo: String? {
          get {
            return snapshot["venmo"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "venmo")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var owner: String? {
          get {
            return snapshot["owner"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class GetVideoQuery: GraphQLQuery {
  public static let operationString =
    "query GetVideo($id: ID!) {\n  getVideo(id: $id) {\n    __typename\n    id\n    viewCount\n    videoURL\n    dare {\n      __typename\n      id\n      title\n      description\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n    }\n    user {\n      __typename\n      id\n      name\n      phoneNumber\n      venmo\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n      owner\n    }\n    createdAt\n    updatedAt\n    dareVideosId\n    userVideosId\n    owner\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getVideo", arguments: ["id": GraphQLVariable("id")], type: .object(GetVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getVideo: GetVideo? = nil) {
      self.init(snapshot: ["__typename": "Query", "getVideo": getVideo.flatMap { $0.snapshot }])
    }

    public var getVideo: GetVideo? {
      get {
        return (snapshot["getVideo"] as? Snapshot).flatMap { GetVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getVideo")
      }
    }

    public struct GetVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("viewCount", type: .scalar(Int.self)),
        GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
        GraphQLField("dare", type: .object(Dare.selections)),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, dare: Dare? = nil, user: User? = nil, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
        self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "dare": dare.flatMap { $0.snapshot }, "user": user.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var viewCount: Int? {
        get {
          return snapshot["viewCount"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "viewCount")
        }
      }

      public var videoUrl: String {
        get {
          return snapshot["videoURL"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoURL")
        }
      }

      public var dare: Dare? {
        get {
          return (snapshot["dare"] as? Snapshot).flatMap { Dare(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "dare")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var dareVideosId: GraphQLID? {
        get {
          return snapshot["dareVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dareVideosId")
        }
      }

      public var userVideosId: GraphQLID? {
        get {
          return snapshot["userVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userVideosId")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Dare: GraphQLSelectionSet {
        public static let possibleTypes = ["Dare"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var description: String? {
          get {
            return snapshot["description"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
          GraphQLField("venmo", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("owner", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var phoneNumber: String {
          get {
            return snapshot["phoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var venmo: String? {
          get {
            return snapshot["venmo"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "venmo")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var owner: String? {
          get {
            return snapshot["owner"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class ListVideosQuery: GraphQLQuery {
  public static let operationString =
    "query ListVideos($filter: ModelVideoFilterInput, $limit: Int, $nextToken: String) {\n  listVideos(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      viewCount\n      videoURL\n      dare {\n        __typename\n        id\n        title\n        description\n        createdAt\n        updatedAt\n      }\n      user {\n        __typename\n        id\n        name\n        phoneNumber\n        venmo\n        createdAt\n        updatedAt\n        owner\n      }\n      createdAt\n      updatedAt\n      dareVideosId\n      userVideosId\n      owner\n    }\n    nextToken\n  }\n}"

  public var filter: ModelVideoFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelVideoFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listVideos", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listVideos: ListVideo? = nil) {
      self.init(snapshot: ["__typename": "Query", "listVideos": listVideos.flatMap { $0.snapshot }])
    }

    public var listVideos: ListVideo? {
      get {
        return (snapshot["listVideos"] as? Snapshot).flatMap { ListVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listVideos")
      }
    }

    public struct ListVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelVideoConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Video"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("viewCount", type: .scalar(Int.self)),
          GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
          GraphQLField("dare", type: .object(Dare.selections)),
          GraphQLField("user", type: .object(User.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
          GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
          GraphQLField("owner", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, dare: Dare? = nil, user: User? = nil, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
          self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "dare": dare.flatMap { $0.snapshot }, "user": user.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var viewCount: Int? {
          get {
            return snapshot["viewCount"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "viewCount")
          }
        }

        public var videoUrl: String {
          get {
            return snapshot["videoURL"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "videoURL")
          }
        }

        public var dare: Dare? {
          get {
            return (snapshot["dare"] as? Snapshot).flatMap { Dare(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "dare")
          }
        }

        public var user: User? {
          get {
            return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "user")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var dareVideosId: GraphQLID? {
          get {
            return snapshot["dareVideosId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "dareVideosId")
          }
        }

        public var userVideosId: GraphQLID? {
          get {
            return snapshot["userVideosId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userVideosId")
          }
        }

        public var owner: String? {
          get {
            return snapshot["owner"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        public struct Dare: GraphQLSelectionSet {
          public static let possibleTypes = ["Dare"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("title", type: .nonNull(.scalar(String.self))),
            GraphQLField("description", type: .scalar(String.self)),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, title: String, description: String? = nil, createdAt: String, updatedAt: String) {
            self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "createdAt": createdAt, "updatedAt": updatedAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var title: String {
            get {
              return snapshot["title"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "title")
            }
          }

          public var description: String? {
            get {
              return snapshot["description"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "description")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
            GraphQLField("venmo", type: .scalar(String.self)),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
            self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var phoneNumber: String {
            get {
              return snapshot["phoneNumber"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "phoneNumber")
            }
          }

          public var venmo: String? {
            get {
              return snapshot["venmo"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "venmo")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class OnCreateDareSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateDare($filter: ModelSubscriptionDareFilterInput) {\n  onCreateDare(filter: $filter) {\n    __typename\n    id\n    title\n    description\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionDareFilterInput?

  public init(filter: ModelSubscriptionDareFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateDare", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateDare.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateDare: OnCreateDare? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateDare": onCreateDare.flatMap { $0.snapshot }])
    }

    public var onCreateDare: OnCreateDare? {
      get {
        return (snapshot["onCreateDare"] as? Snapshot).flatMap { OnCreateDare(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateDare")
      }
    }

    public struct OnCreateDare: GraphQLSelectionSet {
      public static let possibleTypes = ["Dare"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class OnUpdateDareSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateDare($filter: ModelSubscriptionDareFilterInput) {\n  onUpdateDare(filter: $filter) {\n    __typename\n    id\n    title\n    description\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionDareFilterInput?

  public init(filter: ModelSubscriptionDareFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateDare", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateDare.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateDare: OnUpdateDare? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateDare": onUpdateDare.flatMap { $0.snapshot }])
    }

    public var onUpdateDare: OnUpdateDare? {
      get {
        return (snapshot["onUpdateDare"] as? Snapshot).flatMap { OnUpdateDare(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateDare")
      }
    }

    public struct OnUpdateDare: GraphQLSelectionSet {
      public static let possibleTypes = ["Dare"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class OnDeleteDareSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteDare($filter: ModelSubscriptionDareFilterInput) {\n  onDeleteDare(filter: $filter) {\n    __typename\n    id\n    title\n    description\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionDareFilterInput?

  public init(filter: ModelSubscriptionDareFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteDare", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteDare.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteDare: OnDeleteDare? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteDare": onDeleteDare.flatMap { $0.snapshot }])
    }

    public var onDeleteDare: OnDeleteDare? {
      get {
        return (snapshot["onDeleteDare"] as? Snapshot).flatMap { OnDeleteDare(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteDare")
      }
    }

    public struct OnDeleteDare: GraphQLSelectionSet {
      public static let possibleTypes = ["Dare"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class OnCreateUserSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateUser($filter: ModelSubscriptionUserFilterInput, $owner: String) {\n  onCreateUser(filter: $filter, owner: $owner) {\n    __typename\n    id\n    name\n    phoneNumber\n    venmo\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n    owner\n  }\n}"

  public var filter: ModelSubscriptionUserFilterInput?
  public var owner: String?

  public init(filter: ModelSubscriptionUserFilterInput? = nil, owner: String? = nil) {
    self.filter = filter
    self.owner = owner
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "owner": owner]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateUser", arguments: ["filter": GraphQLVariable("filter"), "owner": GraphQLVariable("owner")], type: .object(OnCreateUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateUser: OnCreateUser? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateUser": onCreateUser.flatMap { $0.snapshot }])
    }

    public var onCreateUser: OnCreateUser? {
      get {
        return (snapshot["onCreateUser"] as? Snapshot).flatMap { OnCreateUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateUser")
      }
    }

    public struct OnCreateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("venmo", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var venmo: String? {
        get {
          return snapshot["venmo"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "venmo")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class OnUpdateUserSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateUser($filter: ModelSubscriptionUserFilterInput, $owner: String) {\n  onUpdateUser(filter: $filter, owner: $owner) {\n    __typename\n    id\n    name\n    phoneNumber\n    venmo\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n    owner\n  }\n}"

  public var filter: ModelSubscriptionUserFilterInput?
  public var owner: String?

  public init(filter: ModelSubscriptionUserFilterInput? = nil, owner: String? = nil) {
    self.filter = filter
    self.owner = owner
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "owner": owner]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateUser", arguments: ["filter": GraphQLVariable("filter"), "owner": GraphQLVariable("owner")], type: .object(OnUpdateUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateUser: OnUpdateUser? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateUser": onUpdateUser.flatMap { $0.snapshot }])
    }

    public var onUpdateUser: OnUpdateUser? {
      get {
        return (snapshot["onUpdateUser"] as? Snapshot).flatMap { OnUpdateUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateUser")
      }
    }

    public struct OnUpdateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("venmo", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var venmo: String? {
        get {
          return snapshot["venmo"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "venmo")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class OnDeleteUserSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteUser($filter: ModelSubscriptionUserFilterInput, $owner: String) {\n  onDeleteUser(filter: $filter, owner: $owner) {\n    __typename\n    id\n    name\n    phoneNumber\n    venmo\n    videos {\n      __typename\n      items {\n        __typename\n        id\n        viewCount\n        videoURL\n        createdAt\n        updatedAt\n        dareVideosId\n        userVideosId\n        owner\n      }\n      nextToken\n    }\n    createdAt\n    updatedAt\n    owner\n  }\n}"

  public var filter: ModelSubscriptionUserFilterInput?
  public var owner: String?

  public init(filter: ModelSubscriptionUserFilterInput? = nil, owner: String? = nil) {
    self.filter = filter
    self.owner = owner
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "owner": owner]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteUser", arguments: ["filter": GraphQLVariable("filter"), "owner": GraphQLVariable("owner")], type: .object(OnDeleteUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteUser: OnDeleteUser? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteUser": onDeleteUser.flatMap { $0.snapshot }])
    }

    public var onDeleteUser: OnDeleteUser? {
      get {
        return (snapshot["onDeleteUser"] as? Snapshot).flatMap { OnDeleteUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteUser")
      }
    }

    public struct OnDeleteUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("venmo", type: .scalar(String.self)),
        GraphQLField("videos", type: .object(Video.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var venmo: String? {
        get {
          return snapshot["venmo"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "venmo")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "videos")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVideoConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Video"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("viewCount", type: .scalar(Int.self)),
            GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
            self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var viewCount: Int? {
            get {
              return snapshot["viewCount"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "viewCount")
            }
          }

          public var videoUrl: String {
            get {
              return snapshot["videoURL"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "videoURL")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var dareVideosId: GraphQLID? {
            get {
              return snapshot["dareVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "dareVideosId")
            }
          }

          public var userVideosId: GraphQLID? {
            get {
              return snapshot["userVideosId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userVideosId")
            }
          }

          public var owner: String? {
            get {
              return snapshot["owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "owner")
            }
          }
        }
      }
    }
  }
}

public final class OnCreateVideoSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateVideo($filter: ModelSubscriptionVideoFilterInput, $owner: String) {\n  onCreateVideo(filter: $filter, owner: $owner) {\n    __typename\n    id\n    viewCount\n    videoURL\n    dare {\n      __typename\n      id\n      title\n      description\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n    }\n    user {\n      __typename\n      id\n      name\n      phoneNumber\n      venmo\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n      owner\n    }\n    createdAt\n    updatedAt\n    dareVideosId\n    userVideosId\n    owner\n  }\n}"

  public var filter: ModelSubscriptionVideoFilterInput?
  public var owner: String?

  public init(filter: ModelSubscriptionVideoFilterInput? = nil, owner: String? = nil) {
    self.filter = filter
    self.owner = owner
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "owner": owner]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateVideo", arguments: ["filter": GraphQLVariable("filter"), "owner": GraphQLVariable("owner")], type: .object(OnCreateVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateVideo: OnCreateVideo? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateVideo": onCreateVideo.flatMap { $0.snapshot }])
    }

    public var onCreateVideo: OnCreateVideo? {
      get {
        return (snapshot["onCreateVideo"] as? Snapshot).flatMap { OnCreateVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateVideo")
      }
    }

    public struct OnCreateVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("viewCount", type: .scalar(Int.self)),
        GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
        GraphQLField("dare", type: .object(Dare.selections)),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, dare: Dare? = nil, user: User? = nil, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
        self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "dare": dare.flatMap { $0.snapshot }, "user": user.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var viewCount: Int? {
        get {
          return snapshot["viewCount"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "viewCount")
        }
      }

      public var videoUrl: String {
        get {
          return snapshot["videoURL"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoURL")
        }
      }

      public var dare: Dare? {
        get {
          return (snapshot["dare"] as? Snapshot).flatMap { Dare(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "dare")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var dareVideosId: GraphQLID? {
        get {
          return snapshot["dareVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dareVideosId")
        }
      }

      public var userVideosId: GraphQLID? {
        get {
          return snapshot["userVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userVideosId")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Dare: GraphQLSelectionSet {
        public static let possibleTypes = ["Dare"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var description: String? {
          get {
            return snapshot["description"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
          GraphQLField("venmo", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("owner", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var phoneNumber: String {
          get {
            return snapshot["phoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var venmo: String? {
          get {
            return snapshot["venmo"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "venmo")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var owner: String? {
          get {
            return snapshot["owner"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class OnUpdateVideoSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateVideo($filter: ModelSubscriptionVideoFilterInput, $owner: String) {\n  onUpdateVideo(filter: $filter, owner: $owner) {\n    __typename\n    id\n    viewCount\n    videoURL\n    dare {\n      __typename\n      id\n      title\n      description\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n    }\n    user {\n      __typename\n      id\n      name\n      phoneNumber\n      venmo\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n      owner\n    }\n    createdAt\n    updatedAt\n    dareVideosId\n    userVideosId\n    owner\n  }\n}"

  public var filter: ModelSubscriptionVideoFilterInput?
  public var owner: String?

  public init(filter: ModelSubscriptionVideoFilterInput? = nil, owner: String? = nil) {
    self.filter = filter
    self.owner = owner
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "owner": owner]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateVideo", arguments: ["filter": GraphQLVariable("filter"), "owner": GraphQLVariable("owner")], type: .object(OnUpdateVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateVideo: OnUpdateVideo? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateVideo": onUpdateVideo.flatMap { $0.snapshot }])
    }

    public var onUpdateVideo: OnUpdateVideo? {
      get {
        return (snapshot["onUpdateVideo"] as? Snapshot).flatMap { OnUpdateVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateVideo")
      }
    }

    public struct OnUpdateVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("viewCount", type: .scalar(Int.self)),
        GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
        GraphQLField("dare", type: .object(Dare.selections)),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, dare: Dare? = nil, user: User? = nil, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
        self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "dare": dare.flatMap { $0.snapshot }, "user": user.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var viewCount: Int? {
        get {
          return snapshot["viewCount"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "viewCount")
        }
      }

      public var videoUrl: String {
        get {
          return snapshot["videoURL"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoURL")
        }
      }

      public var dare: Dare? {
        get {
          return (snapshot["dare"] as? Snapshot).flatMap { Dare(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "dare")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var dareVideosId: GraphQLID? {
        get {
          return snapshot["dareVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dareVideosId")
        }
      }

      public var userVideosId: GraphQLID? {
        get {
          return snapshot["userVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userVideosId")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Dare: GraphQLSelectionSet {
        public static let possibleTypes = ["Dare"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var description: String? {
          get {
            return snapshot["description"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
          GraphQLField("venmo", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("owner", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var phoneNumber: String {
          get {
            return snapshot["phoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var venmo: String? {
          get {
            return snapshot["venmo"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "venmo")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var owner: String? {
          get {
            return snapshot["owner"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class OnDeleteVideoSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteVideo($filter: ModelSubscriptionVideoFilterInput, $owner: String) {\n  onDeleteVideo(filter: $filter, owner: $owner) {\n    __typename\n    id\n    viewCount\n    videoURL\n    dare {\n      __typename\n      id\n      title\n      description\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n    }\n    user {\n      __typename\n      id\n      name\n      phoneNumber\n      venmo\n      videos {\n        __typename\n        nextToken\n      }\n      createdAt\n      updatedAt\n      owner\n    }\n    createdAt\n    updatedAt\n    dareVideosId\n    userVideosId\n    owner\n  }\n}"

  public var filter: ModelSubscriptionVideoFilterInput?
  public var owner: String?

  public init(filter: ModelSubscriptionVideoFilterInput? = nil, owner: String? = nil) {
    self.filter = filter
    self.owner = owner
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "owner": owner]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteVideo", arguments: ["filter": GraphQLVariable("filter"), "owner": GraphQLVariable("owner")], type: .object(OnDeleteVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteVideo: OnDeleteVideo? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteVideo": onDeleteVideo.flatMap { $0.snapshot }])
    }

    public var onDeleteVideo: OnDeleteVideo? {
      get {
        return (snapshot["onDeleteVideo"] as? Snapshot).flatMap { OnDeleteVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteVideo")
      }
    }

    public struct OnDeleteVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("viewCount", type: .scalar(Int.self)),
        GraphQLField("videoURL", type: .nonNull(.scalar(String.self))),
        GraphQLField("dare", type: .object(Dare.selections)),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("dareVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("userVideosId", type: .scalar(GraphQLID.self)),
        GraphQLField("owner", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, viewCount: Int? = nil, videoUrl: String, dare: Dare? = nil, user: User? = nil, createdAt: String, updatedAt: String, dareVideosId: GraphQLID? = nil, userVideosId: GraphQLID? = nil, owner: String? = nil) {
        self.init(snapshot: ["__typename": "Video", "id": id, "viewCount": viewCount, "videoURL": videoUrl, "dare": dare.flatMap { $0.snapshot }, "user": user.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "dareVideosId": dareVideosId, "userVideosId": userVideosId, "owner": owner])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var viewCount: Int? {
        get {
          return snapshot["viewCount"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "viewCount")
        }
      }

      public var videoUrl: String {
        get {
          return snapshot["videoURL"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoURL")
        }
      }

      public var dare: Dare? {
        get {
          return (snapshot["dare"] as? Snapshot).flatMap { Dare(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "dare")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var dareVideosId: GraphQLID? {
        get {
          return snapshot["dareVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dareVideosId")
        }
      }

      public var userVideosId: GraphQLID? {
        get {
          return snapshot["userVideosId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userVideosId")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public struct Dare: GraphQLSelectionSet {
        public static let possibleTypes = ["Dare"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, title: String, description: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Dare", "id": id, "title": title, "description": description, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var description: String? {
          get {
            return snapshot["description"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
          GraphQLField("venmo", type: .scalar(String.self)),
          GraphQLField("videos", type: .object(Video.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("owner", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, phoneNumber: String, venmo: String? = nil, videos: Video? = nil, createdAt: String, updatedAt: String, owner: String? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "name": name, "phoneNumber": phoneNumber, "venmo": venmo, "videos": videos.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "owner": owner])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var phoneNumber: String {
          get {
            return snapshot["phoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var venmo: String? {
          get {
            return snapshot["venmo"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "venmo")
          }
        }

        public var videos: Video? {
          get {
            return (snapshot["videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "videos")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var owner: String? {
          get {
            return snapshot["owner"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        public struct Video: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelVideoConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "ModelVideoConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}