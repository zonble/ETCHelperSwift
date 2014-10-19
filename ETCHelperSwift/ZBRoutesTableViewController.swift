import UIKit

class ZBRoutesTableViewController :UITableViewController {
	var delegate :ZBNodesTableViewControllerDelegate?
	var routes :[ZBRoute]?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.routes == nil {
			return 0
		}
		return self.routes!.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
		var route = self.routes![indexPath.row]
		cell.textLabel!.text = "\(route.price)"
		cell.accessoryType = .DisclosureIndicator
		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var controller = ZBRouteTableViewController(style: .Grouped)
		var route = self.routes![indexPath.row]
		controller.route = route
		controller.title = "\(route.price)"
		self.navigationController?.pushViewController(controller, animated: true)
	}
}
