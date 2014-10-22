import Foundation

class ZBRoute {
	var beginNode :ZBNode
	var links :[ZBLink]
	var distance :Double = 0
	var price :Double = 0
	var holidayDistance :Double = 0
	var sections = [[String: AnyObject]]()

	init (beginNode: ZBNode, links :[ZBLink]) {
		self.beginNode = beginNode
		self.links = links

		var lastTag :NSString?
		var lastSection :[String: AnyObject]?
		for link in links {
			distance += link.distance
			price += link.price
			holidayDistance += link.holidayDistance
			if lastTag == nil || lastTag! != link.tag {
				if lastSection != nil {
					self.sections.append(lastSection!)
				}
				lastSection = [String: AnyObject]()
				lastSection?["title"] = link.tag
				var sectionLinks = [ZBLink]()
				sectionLinks.append(link)
				lastSection?["links"] = sectionLinks
			} else {
				var sectionLinks :[ZBLink] = lastSection!["links"]! as [ZBLink]
				sectionLinks.append(link)
				lastSection!["links"] = sectionLinks
			}
			lastTag = link.tag
		}
		self.sections.append(lastSection!)
	}

	var description: String {
		var s = "<\(self.price)> \(self.beginNode.description)"
		for link in links {
			s += "-(\(link.tag))-\(link.to.description)"
		}
		return s
	}
}
