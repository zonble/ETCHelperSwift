import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window :UIWindow?
	var splitViewController :UISplitViewController?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		let rootVC = ZBRootViewController(style: .Grouped)

		splitViewController = UISplitViewController()
		splitViewController!.viewControllers  = splitViewController!.traitCollection.horizontalSizeClass == .Regular ?
			[UINavigationController(rootViewController: rootVC), UIViewController()] :
			[UINavigationController(rootViewController: rootVC)]
		splitViewController!.preferredDisplayMode = .AllVisible

		window!.rootViewController = splitViewController
		window!.makeKeyAndVisible()
		return true
	}
}

