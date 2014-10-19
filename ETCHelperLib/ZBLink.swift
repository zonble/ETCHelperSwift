import Foundation

class ZBLink {
	var to :ZBNode
	var price :Double
	var tag :String

	init(to: ZBNode, price: Double, tag: String) {
		self.to = to
		self.price = price
		self.tag = tag
	}

	var description: String {
		return "<ZBLink to:\(self.to.name) price:\(self.price) tag:\(self.tag)>"
	}
}