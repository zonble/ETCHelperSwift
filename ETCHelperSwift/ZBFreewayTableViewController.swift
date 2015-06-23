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
		let item = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: Selector("close:"))
		self.navigationItem.leftBarButtonItem = item
		self.tableView.rowHeight = 60;

		guard let manager = self.delegate?.routeManagerForFreewaysTableViewController(self) else { return }
		self.freewayNames = manager.freewayNodesMap.keys.array.sort(<)
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.freewayNames?.count ?? 0
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
		cell.accessoryType = .DisclosureIndicator
		let name = self.freewayNames![indexPath.row]
		cell.textLabel?.text = name
		cell.imageView?.image = UIImage(named: name)
		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		guard let manager = self.delegate?.routeManagerForFreewaysTableViewController(self) else {
			return
		}
		guard let name = self.freewayNames?[indexPath.row] else {
			return
		}
		let controller = ZBNodesTableViewController(style: .Grouped)
		controller.delegate = self
		guard let (nodes, _) = manager.freewayNodesMap[name] else {
			return
		}
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
