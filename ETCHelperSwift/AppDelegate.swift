import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		var rootVC = ZBRootViewController(style: .Grouped)
		window!.rootViewController = UINavigationController(rootViewController: rootVC)
		window!.makeKeyAndVisible()
		return true
	}
}

