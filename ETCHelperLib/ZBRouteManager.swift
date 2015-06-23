import Foundation

enum ZBRouteManagerError : ErrorType {
	case NoStartNode
	case NoEndNode
	case StartAndEndAreSame
}

class ZBRouteManager {
	var nodes = [String: ZBNode]()
	var freewayNodesMap = [String: ([ZBNode], [Double])]()

	init(routingDataFileURL: NSURL) {
		let text: NSString?
		do {
			text = try NSString(contentsOfURL: routingDataFileURL, encoding: NSUTF8StringEncoding)
		} catch {
			return
		}

		guard let contents = text else {
			return
		}

		func findOrCreateNodeByName(name :String) -> ZBNode {
			if self.nodes[name] == nil {
				self.nodes[name] = ZBNode(name: name)
			}
			return self.nodes[name]!
		}

		let lines = contents.componentsSeparatedByString("\n")
		for line in lines {
			if !line.hasPrefix("|") || line.hasPrefix("|--") || line.hasPrefix("| #"){
				continue
			}
			let textComponents = line.componentsSeparatedByString("|")
			let components :[String] = textComponents.map {
					($0 as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
				} .filter {
					($0 as NSString).length > 0
				}
			if components.count != 6 {
				continue
			}

			let tag = components[0]
			let from :ZBNode = findOrCreateNodeByName(components[1])
			let to :ZBNode = findOrCreateNodeByName(components[2])
			let distance = (components[3] as NSString).doubleValue
			let price = (components[4] as NSString).doubleValue
			let holidayDistance = (components[5] as NSString).doubleValue
			makeLinks(a: from, b: to, distance: distance, price: price, holidayDistance: holidayDistance, tag: tag)

			var freewayNodes :[ZBNode] = [ZBNode]()
			var freewayDistance :[Double] = [Double]()
			if (self.freewayNodesMap[tag] != nil) {
				(freewayNodes, freewayDistance) = self.freewayNodesMap[tag]!
			} else {
				freewayDistance.append(0)
			}
			if !freewayNodes.contains(from) {
				freewayNodes.append(from)
			}
			if !freewayNodes.contains(to) {
				freewayNodes.append(to)
			}
			freewayDistance.append(freewayDistance.last! + holidayDistance)
			self.freewayNodesMap[tag] = (freewayNodes, freewayDistance)
		}
	}

	func possibleRoutes(from from :ZBNode, to :ZBNode) throws -> [ZBRoute] {

		if self.nodes[from.name] == nil || self.nodes[from.name] != from {
			throw ZBRouteManagerError.NoStartNode
		}
		if self.nodes[to.name] == nil || self.nodes[to.name] != to {
			throw ZBRouteManagerError.NoEndNode
		}
		if from == to {
			throw ZBRouteManagerError.StartAndEndAreSame
		}

		let traveler = ZBRouteTraveler(from: from, to: to)
		var routes = traveler.routes
		routes = routes.sort { (a: ZBRoute, b: ZBRoute) -> Bool in
			return a.price < b.price
		}
		return routes
	}

	func possibleRoutes(from from :String, to :String) throws -> [ZBRoute] {
		func nodeWithName(name: String) -> ZBNode? {
			return self.nodes[name]
		}
		guard let fromNode = nodeWithName(from) else {
			throw ZBRouteManagerError.NoStartNode
		}
		guard let toNode = nodeWithName(to) else {
			throw ZBRouteManagerError.NoEndNode
		}
		return try self.possibleRoutes(from: fromNode, to: toNode)
	}
}

class ZBRouteTraveler {
	var routes = [ZBRoute]()
	var visitedNodes = [ZBNode]()
	var visitedLinks = [ZBLink]()

	var from :ZBNode
	var to :ZBNode

	init(from :ZBNode, to :ZBNode) {
		self.from = from
		self.to = to
		visitedNodes.append(from)
		travelLinksForNode(from)
	}

	func travelLinksForNode(node :ZBNode) -> Void {
		for link in node.links {
			let linkTo = link.to
			if linkTo == to {
				var copy = visitedLinks
				copy.append(link)
				let route = ZBRoute(beginNode: from, links: copy)
				routes.append(route)
				continue
			}
			if visitedNodes.contains(linkTo) {
				continue
			}

			visitedLinks.append(link)
			visitedNodes.append(linkTo)
			travelLinksForNode(linkTo)
			visitedLinks.removeLast()
			visitedNodes.removeLast()
		}
	}
}

