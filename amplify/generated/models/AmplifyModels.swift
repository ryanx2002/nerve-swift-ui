// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "9348fcb8da579fa41c4d26661ed7a006"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Dare.self)
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: Video.self)
  }
}