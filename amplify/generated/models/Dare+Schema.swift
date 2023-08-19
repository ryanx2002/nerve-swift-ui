// swiftlint:disable all
import Amplify
import Foundation

extension Dare {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case description
    case videos
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let dare = Dare.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.read])
    ]
    
    model.pluralName = "Dares"
    
    model.attributes(
      .primaryKey(fields: [dare.id])
    )
    
    model.fields(
      .field(dare.id, is: .required, ofType: .string),
      .field(dare.title, is: .required, ofType: .string),
      .field(dare.description, is: .optional, ofType: .string),
      .hasMany(dare.videos, is: .optional, ofType: Video.self, associatedWith: Video.keys.dare),
      .field(dare.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(dare.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Dare: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}