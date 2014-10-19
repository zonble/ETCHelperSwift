import UIKit

class ZBRoutesTableViewController :UITableViewController {
	var delegate :ZBNodesTableViewControllerDelegate?
	var routes :[ZBRoute]?

	override func viewDidLoad() {
		super.viewDidLoad()
		var backItem = UIBarButtonItem(title: "", style: .Bordered, target: nil, action: nil)
		self.navigationItem.backBarButtonItem = backItem
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.routes == nil {
			return 0
		}
		return self.routes!.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
		}
		var route = self.routes![indexPath.row]
		cell!.textLabel!.text = "\(route.price)"
		cell!.detailTextLabel!.text = (route.sections as NSArray).valueForKeyPath("title").componentsJoinedByString("-")
		cell!.accessoryType = .DisclosureIndicator
		return cell!
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var controller = ZBRouteTableViewController(style: .Grouped)
		var route = self.routes![indexPath.row]
		controller.route = route
		var title = self.title != nil ? self.title! : ""
		controller.title = "\(title) \(route.price)"
		self.navigationController?.pushViewController(controller, animated: true)
	}

	override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if routes == nil {
			return nil
		}
		return "\(routes!.count) route(s)"
	}
}
