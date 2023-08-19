// swiftlint:disable all
import Amplify
import Foundation

extension Video {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case viewCount
    case videoURL
    case dare
    case user
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let video = Video.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read]),
      rule(allow: .private, operations: [.read])
    ]
    
    model.pluralName = "Videos"
    
    model.attributes(
      .primaryKey(fields: [video.id])
    )
    
    model.fields(
      .field(video.id, is: .required, ofType: .string),
      .field(video.viewCount, is: .optional, ofType: .int),
      .field(video.videoURL, is: .required, ofType: .string),
      .belongsTo(video.dare, is: .optional, ofType: Dare.self, targetNames: ["dareVideosId"]),
      .belongsTo(video.user, is: .optional, ofType: User.self, targetNames: ["userVideosId"]),
      .field(video.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(video.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Video: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}