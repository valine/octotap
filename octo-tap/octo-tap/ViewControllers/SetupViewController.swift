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

class SetupViewController : UITableViewController, UITextFieldDelegate {
	
	@IBOutlet weak var serverAddress: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//TODO: Get UI apikey from server
		UserDefaults.standard.set("D58433B85CD84D539ED5A3E7326F82DC", forKey: UserConstants.Server.apiKey.rawValue)
		serverAddress.delegate = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func doneTapped(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		print(textField.text!)
		return true
	}
	
	
		
	
//	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return 0 // your number of cell here
//	}
//	
//	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		// your cell coding
//		return UITableViewCell()
//	}
//	
//	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
//		// cell selected code here
//	}
}
