// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var name: String
  public var phoneNumber: String?
  public var venmo: String?
  public var videos: List<Video>?
  public var email: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String,
      phoneNumber: String? = nil,
      venmo: String? = nil,
      videos: List<Video>? = [],
      email: String) {
    self.init(id: id,
      name: name,
      phoneNumber: phoneNumber,
      venmo: venmo,
      videos: videos,
      email: email,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String,
      phoneNumber: String? = nil,
      venmo: String? = nil,
      videos: List<Video>? = [],
      email: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.phoneNumber = phoneNumber
      self.venmo = venmo
      self.videos = videos
      self.email = email
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}