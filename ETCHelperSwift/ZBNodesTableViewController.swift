import UIKit

protocol ZBNodesTableViewControllerDelegate {
	func nodesTableViewController(controller :ZBNodesTableViewController, didSelectNode node :ZBNode)
}

class ZBNodesTableViewController :UITableViewController {
	var delegate :ZBNodesTableViewControllerDelegate?
	var nodes :[ZBNode]?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Pick an Exit"
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.nodes?.count ?? 0
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell?
		if cell == nil {
			cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
		}
		guard let node = self.nodes?[indexPath.row] else {
			return cell!
		}
		cell?.textLabel?.text = node.name
		return cell!
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let node = nodes![indexPath.row]
		delegate?.nodesTableViewController(self, didSelectNode: node)
		self.navigationController?.popViewControllerAnimated(true)
	}
}
