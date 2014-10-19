import Foundation

class ZBRoute {
	var beginNode :ZBNode
	var links :[ZBLink]
	var price :Double = 0

	init (beginNode: ZBNode, links :[ZBLink]) {
		self.beginNode = beginNode
		self.links = links

		var totalPrice :Double = 0
		for link in links {
			totalPrice += link.price
		}
		self.price = totalPrice
	}

	var description: String {
		var s = "<\(self.price)> \(self.beginNode.description)"
		for link in links {
			s += "-(\(link.tag))-\(link.to.description)"
		}
		return s
	}
}
