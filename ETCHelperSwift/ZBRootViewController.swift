import UIKit

class ZBRootViewController: UITableViewController, ZBFreewayTableViewControllerDelegate {
	var manager :ZBRouteManager
	var from :ZBNode?
	var to: ZBNode?
	var fromPicker = ZBFreewayTableViewController(style: .Grouped)
	var toPicker = ZBFreewayTableViewController(style: .Grouped)

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		manager = ZBRouteManager(routingDataFileURL: NSBundle.mainBundle().URLForResource("data", withExtension: "txt")!)
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		fromPicker.delegate = self
		toPicker.delegate = self
	}

	override init(style: UITableViewStyle) {
		manager = ZBRouteManager(routingDataFileURL: NSBundle.mainBundle().URLForResource("data", withExtension: "txt")!)
		super.init(style: style)
		fromPicker.delegate = self
		toPicker.delegate = self
	}

	required init(coder aDecoder: NSCoder) {
		manager = ZBRouteManager(routingDataFileURL: NSBundle.mainBundle().URLForResource("data", withExtension: "txt")!)
		super.init(coder: aDecoder)
		fromPicker.delegate = self
		toPicker.delegate = self
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "ETC Helper"
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		var backItem = UIBarButtonItem(title: "", style: .Bordered, target: nil, action: nil)
		self.navigationItem.backBarButtonItem = backItem
	}

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3
	}
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
		cell.textLabel.textColor = UIColor.blackColor()
		cell.textLabel.textAlignment = .Left
		switch indexPath.section {
		case 0:
			cell.textLabel.text = self.from != nil ? self.from!.name : "Not Set Yet"
			cell.accessoryType = .DisclosureIndicator
		case 1:
			cell.textLabel.text = self.to != nil ? self.to!.name : "Not Set Yet"
			cell.accessoryType = .DisclosureIndicator
		case 2:
			cell.textLabel.text = "Go!"
			cell.accessoryType = .None
			cell.textLabel.textColor = UIColor.blueColor()
			cell.textLabel.textAlignment = .Center
		default:
			break
		}
		return cell
	}

	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section < 2 {
			return ["From", "To"][section]
		}
		return nil
	}

	func cal() {
		if self.from == nil {
			UIAlertView(title: "You did not select the start.", message: "Please select your start.", delegate: nil, cancelButtonTitle: "Dismiss").show()
			return
		}
		if self.to == nil {
			UIAlertView(title: "You did not select the destination.", message: "Please select your destination.", delegate: nil, cancelButtonTitle: "Dismiss").show()
			return
		}

		var error: NSError?
		var routes = self.manager.possibleRoutes(from: self.from!, to: self.to!, error: &error)
		if error != nil {
			UIAlertView(title: error!.localizedDescription, message: "", delegate: nil, cancelButtonTitle: "Dismiss").show()
			return
		}
		let controller = ZBRoutesTableViewController(style: .Grouped)
		controller.title = "\(self.from!.name) - \(self.to!.name)"
		controller.routes = routes
		var appDelegate :AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		appDelegate.splitViewController!.showDetailViewController(UINavigationController(rootViewController: controller), sender: self)
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)

		func presentViewController(vc :UIViewController) {
			var nav = UINavigationController(rootViewController: vc)
			nav.preferredContentSize = CGSizeMake(320, 600)
			nav.modalPresentationStyle = UIModalPresentationStyle.Popover
			var cell = tableView.cellForRowAtIndexPath(indexPath)
			nav.popoverPresentationController!.sourceView = cell!
			nav.popoverPresentationController!.sourceRect = cell!.bounds
			self.presentViewController(nav, animated: true, completion: nil)
		}

		switch indexPath.section {
		case 0:
			presentViewController(fromPicker)
		case 1:
			presentViewController(toPicker)
		case 2:
			self.cal()
		default:
			break
		}
	}

	func routeManagerForFreewaysTableViewController(controller : ZBFreewayTableViewController) -> ZBRouteManager {
		return self.manager
	}

	func freewayTableViewController(controller : ZBFreewayTableViewController, didSelectNode node: ZBNode) -> Void {
		switch controller {
		case self.fromPicker:
			self.from = node
		case self.toPicker:
			self.to = node
		default:
			break
		}
		self.tableView.reloadData()
	}

}
