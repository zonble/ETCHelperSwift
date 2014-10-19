import Foundation

/** Data object for a node. */
class ZBNode: Hashable {
	var name :String
	var links :[ZBLink] = [ZBLink]()

	init(name: String) {
		self.name = name
	}

	var description: String {
		return "<ZBNode \(self.name)>"
	}

	var hashValue: Int {
		return self.name.hashValue
	}

	func makeLink(#to: ZBNode, price :Double, tag :String) {
		let link = ZBLink(to: to, price: price, tag: tag)
		self.links.append(link)
	}
}

func makeLinks(#a: ZBNode, b: ZBNode, price: Double, tag: NSString) {
	a.makeLink(to: b, price: price, tag: tag)
	b.makeLink(to: a, price: price, tag: tag)
}

func ==(lhs: ZBNode, rhs: ZBNode) -> Bool {
	return lhs.hashValue == rhs.hashValue
}
