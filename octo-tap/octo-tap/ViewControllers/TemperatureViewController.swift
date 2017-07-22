//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import UIKit

class TemperatureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var toolTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		toolTableView.delegate = self
		toolTableView.dataSource = self
		toolTableView.separatorColor = Constants.Colors.almostBlack
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//TODO pull number of tools
		return 3
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 110;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:ToolCell = self.toolTableView.dequeueReusableCell(withIdentifier: Constants.TabelCellResuseIDs.toolCell.rawValue) as! ToolCell!
		
		if (indexPath.item == indexPath.endIndex) {
			cell.hideExtruderControls()
			cell.toolNameLabel.text = Constants.Strings.bedToolName
		} else {
			cell.toolNameLabel.text = "\(Constants.Strings.toolName) \(indexPath.item)"
		}
		return cell
	}
	
}
