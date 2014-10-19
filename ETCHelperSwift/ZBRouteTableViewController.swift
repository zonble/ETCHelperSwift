import UIKit

class ZBRouteTableViewController :UITableViewController {
	var delegate :ZBNodesTableViewControllerDelegate?
	var route :ZBRoute?
	var currencyFormatter = NSNumberFormatter()

	override func viewDidLoad() {
		super.viewDidLoad()
		currencyFormatter.numberStyle = .CurrencyStyle
		currencyFormatter.locale = NSLocale(localeIdentifier: "zh_Hant_TW")
	}

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if self.route == nil {
			return 1
		}
		return self.route!.sections.count + 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.route == nil {
			return 0
		}
		if section == 0 {
			return 3
		}
		let linkSection = self.route!.sections[section-1]
		let links = linkSection["links"]! as [ZBLink]
		return links.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
		}

		cell!.selectionStyle = .None
		if indexPath.section == 0 {
			switch indexPath.row {
			case 0:
				cell!.textLabel!.text = "牌價"
				cell!.detailTextLabel!.text = currencyFormatter.stringFromNumber(self.route!.price)
			case 1:
				cell!.textLabel!.text = "國慶日連續假期里程"
				cell!.detailTextLabel!.text = "\(route!.holidayDistance) km"
			case 2:
				cell!.textLabel!.text = "國慶日連續假期收費"
				var holidayPrice = self.route!.holidayDistance * 0.9
				cell!.detailTextLabel!.text = currencyFormatter.stringFromNumber(holidayPrice)
			default:
				break
			}
			return cell!
		}

		let linkSection = self.route!.sections[indexPath.section-1]
		let links = linkSection["links"]! as [ZBLink]
		let link = links[indexPath.row]
		var previousNode : ZBNode!

		if indexPath.row == 0 {
			if indexPath.section == 1 {
				previousNode = self.route!.beginNode
			} else {
				let lastLinkSection = self.route!.sections[indexPath.section - 2]
				let lastLinks = lastLinkSection["links"]! as [ZBLink]
				previousNode = lastLinks[lastLinks.count-1].to
			}
		} else {
			previousNode = links[indexPath.row-1].to
		}

		cell!.textLabel!.text = "\(previousNode.name) - \(link.to.name)"
		cell!.detailTextLabel!.text = currencyFormatter.stringFromNumber(link.price)
		return cell!
	}

	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return nil
		}
		let linkSection = self.route!.sections[section-1]
		let title = linkSection["title"]! as NSString
		return title
	}
}