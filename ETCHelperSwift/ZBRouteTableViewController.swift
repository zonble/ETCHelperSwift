import UIKit

enum CellTypes {
	case Distance, Price
	case LongDistanceDiscount, DailyDiscount, LongDistanceAndDailyDiscount
	case HolidayDiscount
}

class ZBRouteTableViewController :UITableViewController {
	var cellTypes = [CellTypes]()
	var route :ZBRoute? {
		didSet {
			self.cellTypes = [CellTypes]()
			cellTypes.append(.Price)
			cellTypes.append(.Distance)
			let distance = route!.distance
			if distance > 200 {
				cellTypes.append(.LongDistanceDiscount)
				cellTypes.append(.LongDistanceAndDailyDiscount)
			} else {
				cellTypes.append(.DailyDiscount)
			}
			cellTypes.append(.HolidayDiscount)
		}
	}

	var currencyFormatter = NSNumberFormatter()
	var distanceFormatter = NSLengthFormatter()

	override func viewDidLoad() {
		super.viewDidLoad()
		currencyFormatter.numberStyle = .CurrencyStyle
		currencyFormatter.minimumFractionDigits = 1
		currencyFormatter.maximumFractionDigits = 1
		let taiwanLocale = NSLocale(localeIdentifier: "zh_Hant_TW");
		currencyFormatter.locale = taiwanLocale
		distanceFormatter.numberFormatter.locale = taiwanLocale

		let item = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("share:"))
		self.navigationItem.rightBarButtonItem = item
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
			return self.cellTypes.count
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

		cell?.textLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody);
		cell!.indentationLevel = 0

		cell!.selectionStyle = .None
		if indexPath.section == 0 {
			let type = self.cellTypes[indexPath.row]
			switch type {
			case .Distance:
				cell!.textLabel.text = "里程"
				var str = self.distanceFormatter.stringFromMeters(route!.distance * 1000)
				cell!.detailTextLabel!.text = str
			case .Price:
				cell!.textLabel.text = "牌價"
				cell!.detailTextLabel!.text = currencyFormatter.stringFromNumber(self.route!.price)
			case .LongDistanceDiscount:
				cell!.indentationLevel = 1
				cell!.textLabel.text = "扣長途優惠後"
				cell!.detailTextLabel!.text = currencyFormatter.stringFromNumber(self.route!.priceAfterLongDistanceDiscount)
			case .LongDistanceAndDailyDiscount:
				cell!.indentationLevel = 1
				cell!.textLabel.text = "扣優惠里程與長途優惠後"
				cell!.detailTextLabel!.text = currencyFormatter.stringFromNumber(self.route!.priceAfterLongDistanceAndDailyDiscount)
			case .DailyDiscount:
				cell!.indentationLevel = 1
				cell!.textLabel.text = "扣優惠里程後"
				cell!.detailTextLabel!.text = currencyFormatter.stringFromNumber(self.route!.priceAfterDailyDiscount)
			case .HolidayDiscount:
				cell!.indentationLevel = 1
				cell!.textLabel.text = "國慶假期收費 (里程x0.9)"
				cell!.detailTextLabel!.text = currencyFormatter.stringFromNumber(self.route!.priceAfterHolidayDiscount)
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

		cell!.textLabel.text = "\(previousNode.name) - \(link.to.name)"
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

	func share(sender: AnyObject) {
		if self.route == nil {
			return
		}
		let report = self.route!.plainTextReport
		let vc = UIActivityViewController(activityItems: [report], applicationActivities: nil)
		self.presentViewController(vc, animated: true, completion: nil)
	}
}

