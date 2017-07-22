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

class FileBrowserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var filesTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		filesTableView.delegate = self
		filesTableView.dataSource = self
		filesTableView.separatorColor = Constants.Colors.almostBlack
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//TODO pull number of tools
		return 3
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 73;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:FilesCell = self.filesTableView.dequeueReusableCell(withIdentifier: Constants.TabelCellResuseIDs.filesCell.rawValue) as! FilesCell!
	
		return cell
	}
	

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

