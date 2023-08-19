// swiftlint:disable all
import Amplify
import Foundation

public struct Dare: Model {
  public let id: String
  public var title: String
  public var description: String?
  public var videos: List<Video>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      title: String,
      description: String? = nil,
      videos: List<Video>? = []) {
    self.init(id: id,
      title: title,
      description: description,
      videos: videos,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      title: String,
      description: String? = nil,
      videos: List<Video>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.title = title
      self.description = description
      self.videos = videos
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}