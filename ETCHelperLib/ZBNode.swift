import Foundation

/** Data object for a node. */
class ZBNode :Equatable {
	var name :String
	var links :[ZBLink] = [ZBLink]()

	init(name: String) {
		self.name = name
	}

	var description: String {
		return "<ZBNode \(self.name)>"
	}

	func makeLink(to to: ZBNode, distance :Double, price :Double, holidayDistance :Double, tag :String) {
		let link = ZBLink(to: to, distance: distance, price: price, holidayDistance: holidayDistance, tag: tag)
		self.links.append(link)
	}
}

func makeLinks(a a: ZBNode, b: ZBNode, distance :Double, price: Double, holidayDistance :Double, tag: String) {
	a.makeLink(to: b, distance: distance, price: price, holidayDistance: holidayDistance, tag: tag as String)
	b.makeLink(to: a, distance: distance, price: price, holidayDistance: holidayDistance, tag: tag as String)
}

func ==(lhs: ZBNode, rhs: ZBNode) -> Bool {
	return lhs === rhs
}
