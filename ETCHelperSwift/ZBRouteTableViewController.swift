import UIKit

class ZBRouteTableViewController :UITableViewController {
	var delegate :ZBNodesTableViewControllerDelegate?
	var route :ZBRoute?

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if self.route == nil {
			return 0
		}
		return self.route!.sections.count
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.route == nil {
			return 0
		}
		let linkSection = self.route!.sections[section]
		let links = linkSection["links"]! as [ZBLink]
		return links.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
		}
		let linkSection = self.route!.sections[indexPath.section]
		let links = linkSection["links"]! as [ZBLink]
		let link = links[indexPath.row]

		var previousNode : ZBNode!

		if indexPath.row == 0 {
			if indexPath.section == 0 {
				previousNode = self.route!.beginNode
			} else {
				let lastLinkSection = self.route!.sections[indexPath.section - 1]
				let lastLinks = lastLinkSection["links"]! as [ZBLink]
				previousNode = lastLinks[lastLinks.count-1].to
			}
		} else {
			previousNode = links[indexPath.row-1].to
		}

		cell!.textLabel!.text = "\(previousNode.name) - \(link.to.name)"
		cell!.detailTextLabel!.text = "\(link.price)"
		cell!.selectionStyle = .None
		return cell!
	}

	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let linkSection = self.route!.sections[section]
		let title = linkSection["title"]! as NSString
		return title
	}
}