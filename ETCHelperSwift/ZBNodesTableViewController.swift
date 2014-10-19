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
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.nodes == nil {
			return 0
		}
		return self.nodes!.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
		var node = nodes![indexPath.row]
		cell.textLabel!.text = node.name
		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var node = nodes![indexPath.row]
		delegate?.nodesTableViewController(self, didSelectNode: node)
		self.navigationController?.popViewControllerAnimated(true)
	}
}
