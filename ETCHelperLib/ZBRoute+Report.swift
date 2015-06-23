import Foundation

extension ZBRoute {
	var plainTextReport : String {
		get {
			let currencyFormatter = NSNumberFormatter()
			let distanceFormatter = NSLengthFormatter()
			let taiwanLocale = NSLocale(localeIdentifier: "zh_Hant_TW");
			currencyFormatter.numberStyle = .CurrencyStyle
			currencyFormatter.locale = taiwanLocale
			distanceFormatter.numberFormatter.locale = taiwanLocale
			
			var s = "\(self.beginNode.name)-\(self.links.last!.to.name)\n\n"
			s += "里程: \(distanceFormatter.stringFromMeters(self.distance * 1000))\n"
			s += "牌價: \(currencyFormatter.stringFromNumber(self.price)!)\n"
			if self.distance > 200 {
				s += "- 扣長途優惠後: \(currencyFormatter.stringFromNumber(self.priceAfterLongDistanceDiscount)!)"
				s += "- 扣優惠里程與長途優惠後: \(currencyFormatter.stringFromNumber(self.priceAfterLongDistanceAndDailyDiscount)!)"
			} else {
				s += "- 扣優惠里程後: \(currencyFormatter.stringFromNumber(self.priceAfterDailyDiscount)!)"
			}
			s += "- 國慶假期收費: \(currencyFormatter.stringFromNumber(self.priceAfterHolidayDiscount)!)\n"
			s += "\n"

			var sectionIndex = 0
			for section in self.sections {
				let title = section["title"]! as! NSString
				s += "== \(title) ==\n"

				let links = section["links"]! as! [ZBLink]
				var rowIndex = 0
				for link in links {
					var previousNode : ZBNode!
					if rowIndex == 0 {
						if sectionIndex == 0 {
							previousNode = self.beginNode
						} else {
							let lastLinkSection = self.sections[sectionIndex - 1]
							let lastLinks = lastLinkSection["links"]! as! [ZBLink]
							previousNode = lastLinks[lastLinks.count-1].to
						}
					} else {
						previousNode = links[rowIndex-1].to
					}
					s += "\(previousNode.name) - \(link.to.name)\t\(currencyFormatter.stringFromNumber(link.price)!) \(distanceFormatter.stringFromMeters(link.distance * 1000))\n"
					rowIndex++
				}
				s += "\n"
				sectionIndex++
			}
			return s
		}
	}
}
