import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DataProvider.shared.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.rootViewController = RepositoryListController()
            window.makeKeyAndVisible()
        }
        
        return true
    }
}

