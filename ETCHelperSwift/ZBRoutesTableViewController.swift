import UIKit

class ZBRoutesTableViewController :UITableViewController {
	var routes :[ZBRoute]?

	override func viewDidLoad() {
		super.viewDidLoad()
		let backItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
		self.navigationItem.backBarButtonItem = backItem
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.routes == nil {
			return 0
		}
		return self.routes!.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell?
		if cell == nil {
			cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
		}
		var route = self.routes![indexPath.row]
		cell?.textLabel?.text = "\(route.price)"

		func titleFromRoute(route:ZBRoute) -> String {
			var s :String = route.beginNode.name
			let sections = route.sections
			for section in sections {
				let title = section["title"]! as! String
				let links = section["links"]! as! [ZBLink]
				let link = links.last
				s += "-\(title)-\(link!.to.name)"
			}
			return s
		}

		cell!.detailTextLabel!.text = titleFromRoute(route)
		cell!.accessoryType = .DisclosureIndicator
		return cell!
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let controller = ZBRouteTableViewController(style: .Grouped)
		let route = self.routes![indexPath.row]
		controller.route = route
		let title = self.title != nil ? self.title! : ""
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
