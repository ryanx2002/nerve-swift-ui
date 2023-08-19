// swiftlint:disable all
import Amplify
import Foundation

public struct Video: Model {
  public let id: String
  public var viewCount: Int?
  public var videoURL: String
  public var dare: Dare?
  public var user: User?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      viewCount: Int? = nil,
      videoURL: String,
      dare: Dare? = nil,
      user: User? = nil) {
    self.init(id: id,
      viewCount: viewCount,
      videoURL: videoURL,
      dare: dare,
      user: user,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      viewCount: Int? = nil,
      videoURL: String,
      dare: Dare? = nil,
      user: User? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.viewCount = viewCount
      self.videoURL = videoURL
      self.dare = dare
      self.user = user
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}