import UIKit

class ZBRoutesTableViewController :UITableViewController {
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
		cell!.textLabel.text = "\(route.price)"

		func titleFromRoute(route:ZBRoute) -> String {
			var s :String = route.beginNode.name
			var sections = route.sections
			for section in sections {
				var title = section["title"]! as String
				var links = section["links"]! as [ZBLink]
				var link = links.last
				s += "-\(title)-\(link!.to.name)"
			}
			return s
		}

		cell!.detailTextLabel!.text = titleFromRoute(route)
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
