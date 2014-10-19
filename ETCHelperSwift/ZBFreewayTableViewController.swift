import UIKit

protocol ZBFreewayTableViewControllerDelegate {
	func routeManagerForFreewaysTableViewController(controller : ZBFreewayTableViewController) -> ZBRouteManager
	func freewayTableViewController(controller : ZBFreewayTableViewController, didSelectNode node: ZBNode) -> Void
}

class ZBFreewayTableViewController :UITableViewController, ZBNodesTableViewControllerDelegate {
	var delegate :ZBFreewayTableViewControllerDelegate?
	var freewayNames :[String]?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Pick a Highway"
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		var manager = self.delegate?.routeManagerForFreewaysTableViewController(self)
		if manager != nil {
			var freewayNames = [String]()
			for freeway in manager!.freewayNodesMap.keys {
				freewayNames.append(freeway)
			}
			freewayNames = freewayNames.sorted {
				return $0 < $1
			}
			self.freewayNames = freewayNames
		}

		let item = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: Selector("close:"))
		self.navigationItem.leftBarButtonItem = item
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.freewayNames == nil {
			return 0
		}
		return self.freewayNames!.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
		cell.accessoryType = .DisclosureIndicator
		cell.textLabel!.text = self.freewayNames![indexPath.row]
		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var manager = self.delegate?.routeManagerForFreewaysTableViewController(self)
		if manager == nil {
			return
		}
		let name = self.freewayNames![indexPath.row]
		let controller = ZBNodesTableViewController(style: .Grouped)
		controller.delegate = self
		var (nodes, dist) = manager!.freewayNodesMap[name]!
		controller.nodes = nodes
		self.navigationController?.pushViewController(controller, animated: true)
	}

	func close(sender :AnyObject?) {
		self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion:nil)
	}

	func nodesTableViewController(controller :ZBNodesTableViewController, didSelectNode node :ZBNode) {
		self.delegate?.freewayTableViewController(self, didSelectNode: node)
		self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion:nil)
	}
}
