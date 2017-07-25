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

class MoreViewController: UITableViewController {
	
	
	override func viewDidLoad() {

		self.navigationController?.navigationBar.tintColor = Constants.Colors.linkBlue
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(false, animated: animated);
		super.viewWillDisappear(animated)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
		
		for cell in self.tableView.visibleCells {
			cell.contentView.superview?.backgroundColor = .clear
		}
	}
	
	override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		let cell  = tableView.cellForRow(at: indexPath)

		cell!.contentView.superview?.backgroundColor = Constants.Colors.linkBlue
	}
	


}
