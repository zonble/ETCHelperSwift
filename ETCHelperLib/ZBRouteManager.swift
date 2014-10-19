import Foundation

let ZBRouteManagerErrorDomain = "ZBRouteManagerErrorDomain"

class ZBRouteManager {
	var nodes = [String: ZBNode]()
	var freewayNodesMap = [String: [ZBNode]]()

	init(routingDataFileURL: NSURL) {
		var error :NSError?
		let text = NSString(contentsOfURL: routingDataFileURL, encoding: NSUTF8StringEncoding, error: &error)
		if error != nil {
			return
		}

		func findOrCreateNodeByName(name :String) -> ZBNode {
			if self.nodes[name] == nil {
				self.nodes[name] = ZBNode(name: name)
			}
			return self.nodes[name]!
		}

		let lines = text.componentsSeparatedByString("\n")
		for line in lines {
			if line.hasPrefix("#") {
				continue
			}
			let components = line.componentsSeparatedByString(",") as [String]
			if components.count != 4 {
				continue
			}
			let tag = components[0]
			let from :ZBNode = findOrCreateNodeByName(components[1])
			let to :ZBNode = findOrCreateNodeByName(components[2])
			makeLinks(a: from, to, (components[3] as NSString).doubleValue, tag)

			var freewayNodes :[ZBNode]? = self.freewayNodesMap[tag]
			if freewayNodes == nil {
				freewayNodes = [ZBNode]()
				self.freewayNodesMap[tag] = freewayNodes
			}

			if !contains(freewayNodes!, from) {
				freewayNodes?.append(from)
			}
			if !contains(freewayNodes!, to) {
				freewayNodes?.append(to)
			}
		}
	}

	func possibleRoutes(#from :ZBNode, to :ZBNode, error: NSErrorPointer) -> [ZBRoute] {

		if self.nodes[from.name] == nil {
			error.memory = NSError(domain: ZBRouteManagerErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : "We do not have the node as the start."])
			return []
		}
		if self.nodes[from.name] != from {
			error.memory = NSError(domain: ZBRouteManagerErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : "We do not have the node as the start."])
			return []
		}
		if self.nodes[to.name] == nil {
			error.memory = NSError(domain: ZBRouteManagerErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : "We do not have the node as the destination."])
			return []
		}
		if self.nodes[to.name] != to {
			error.memory = NSError(domain: ZBRouteManagerErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : "We do not have the node as the destination."])
			return []
		}
		if from == to {
			error.memory = NSError(domain: ZBRouteManagerErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : "We do not have the node as the destination."])
			return []
		}

		var traveler = ZBRouteTraveler(from: from, to: to)
		var routes = traveler.routes
		routes = routes.sorted { (a: ZBRoute, b: ZBRoute) -> Bool in
			return a.price < b.price
		}
		return routes
	}

	func possibleRoutes(#from :String, to :String, error: NSErrorPointer) -> [ZBRoute] {
		func nodeWithName(name: String) -> ZBNode? {
			return self.nodes[name]
		}
		var fromNode = nodeWithName(from)
		if fromNode == nil {
			error.memory = NSError(domain: ZBRouteManagerErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : "We cannot find the node to start."])
			return []
		}
		var toNode = nodeWithName(to)
		if toNode == nil {
			error.memory = NSError(domain: ZBRouteManagerErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : "We cannot find the destination node."])
			return []
		}
		return self.possibleRoutes(from: fromNode!, to: toNode!, error: error)
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
			var linkTo = link.to
			if linkTo == to {
				var copy = visitedLinks
				copy.append(link)
				let route = ZBRoute(beginNode: from, links: copy)
				routes.append(route)
				continue
			}
			if contains(visitedNodes, linkTo) {
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


