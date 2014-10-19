import UIKit
import XCTest

class ETCHelperSwiftTests: XCTestCase {
	var manager : ZBRouteManager!

    override func setUp() {
        super.setUp()
		var bundle = NSBundle(forClass: ETCHelperSwiftTests.self)
		var fileURL = bundle.URLForResource("data", withExtension: "txt")
		self.manager = ZBRouteManager(routingDataFileURL: fileURL!)
    }
    
    override func tearDown() {
        super.tearDown()
    }

	func testAllNodes() {
		XCTAssert(self.manager.nodes.count > 0, "Must have nodes")
		for key in self.manager.nodes.keys {
			var node = self.manager.nodes[key]!
			XCTAssert((node.name as NSString).length > 0, "Must have names")
			XCTAssert(node.links.count > 0, "Must have links")
		}
	}

	func testRoutesBetweenArbitraryNames() {
		var nodeCount :UInt32 = UInt32(self.manager.nodes.count)
		var rand1 :Int = Int(arc4random_uniform(nodeCount))
		var rand2 :Int = Int(arc4random_uniform(nodeCount))
		while (rand2 == rand1) {
			rand2 = Int(arc4random_uniform(nodeCount))
		}
		self.manager.nodes.keys
		var fromKey :NSString = (self.manager.nodes as NSDictionary).allKeys[rand1] as NSString
		var toKey :NSString = (self.manager.nodes as NSDictionary).allKeys[rand2] as NSString
		var routes = self.manager.possibleRoutes(from: fromKey, to: toKey, error: nil)
		XCTAssert(routes.count > 0, "We must have routes")
	}
}
