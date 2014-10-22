import Foundation

class ZBLink {
	var to :ZBNode
	var distance :Double
	var price :Double
	var holidayDistance :Double
	var tag :String

	init(to: ZBNode, distance :Double, price: Double, holidayDistance: Double, tag: String) {
		self.to = to
		self.distance = distance
		self.price = price
		self.holidayDistance = holidayDistance
		self.tag = tag
	}

	var description: String {
		return "<ZBLink to:\(self.to.name) price:\(self.price) tag:\(self.tag)>"
	}
}