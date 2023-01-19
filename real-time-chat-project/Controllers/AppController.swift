import UIKit
import Firebase

final class AppController {
  static let shared = AppController()
  private var window: UIWindow!
  private var rootViewController: UIViewController? {
    didSet {
      window.rootViewController = rootViewController
    }
  }

  init() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleAppState),
      name: .AuthStateDidChange,
      object: nil)
  }

  func configureFirebase() {
    FirebaseApp.configure()
  }

  func show(in window: UIWindow?) {
    guard let window = window else {
      fatalError("Cannot layout app with a nil window.")
    }

    self.window = window
    window.tintColor = .primary
    window.backgroundColor = .white

    handleAppState()

    window.makeKeyAndVisible()
  }

  @objc private func handleAppState() {
    if let user = Auth.auth().currentUser {
      let channelsViewController = ChannelsViewController(currentUser: user)
      rootViewController = NavigationController(channelsViewController)
    } else {
      rootViewController = LoginViewController()
    }
  }
}
