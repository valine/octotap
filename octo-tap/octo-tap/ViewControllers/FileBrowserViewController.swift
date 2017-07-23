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
	
	var files: OctoFiles?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		filesTableView.delegate = self
		filesTableView.dataSource = self
	
		let apiKey = UserDefaults.standard.string(forKey: Constants.Server.apiKey.rawValue)
		let serverAddress = UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)
		
		let octoPrint = Octoprint()
		
		octoPrint.getFiles(address: URL(string: (serverAddress?.withHttp())!)!, apiKey: apiKey!, completion: {(files: OctoFiles?, error: Error?) -> Void in
			self.files = files
			self.filesTableView.reloadData()
		})
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//TODO pull number of tools
		
		if let filesCount  =  (files?.files.count) {
			return filesCount
		}
		
		return 0
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let cellHeight: CGFloat = 73
		return cellHeight;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:FilesCell = self.filesTableView.dequeueReusableCell(withIdentifier: Constants.TabelCellResuseIDs.filesCell.rawValue) as! FilesCell!
		
		let file = files?.files[indexPath.item]
		cell.nameLabel.text = file?.name
		
		
		if let success = file?.print?.last?.success {
			if success {
				cell.nameLabel.textColor = Constants.Colors.octotapGreen
			} else {
				cell.nameLabel.textColor = Constants.Colors.errorRed
			}
		} else {
			cell.nameLabel.textColor = .white
		}
		
	
		return cell
	}
	

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

