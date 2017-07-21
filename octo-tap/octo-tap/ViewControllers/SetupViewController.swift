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
	
	@IBOutlet weak var serverAddressStatus: UILabel!
	@IBOutlet weak var serverAddressInput: UITextField!
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		//TODO: Get UI apikey from server
		UserDefaults.standard.set("D58433B85CD84D539ED5A3E7326F82DC", forKey: Constants.Server.apiKey.rawValue)
		serverAddressInput.delegate = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func join(_ sender: Any) {
		//dismiss(animated: true, completion: nil)
		if let userInput = serverAddressInput.text {
			UserDefaults.standard.set(userInput.withHttp(), forKey: Constants.Server.address.rawValue)
		}
		
		let apikey = UserDefaults.standard.string(forKey: Constants.Server.apiKey.rawValue)
		let serverAddress = URL(string: UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)!)
		let octoprint = Octoprint()
		
		if let validURL = serverAddress {
			octoprint.getUIApiKey(address: validURL, completion: {(keyString: String?, error : Error?) -> Void in
				if (error != nil) {
					self.serverAddressInput.textColor =  Constants.Colors.errorRed
					self.serverAddressStatus.textColor = Constants.Colors.errorRed
					self.serverAddressStatus.text = Constants.Strings.badConnections
				} else {
					//print(keyString!)
					self.serverAddressInput.textColor = Constants.Colors.octotapGreen
					self.serverAddressStatus.textColor = Constants.Colors.octotapGreen
					self.serverAddressStatus.text = Constants.Strings.successful
				}
			})
		} else {
			serverAddressInput.textColor = Constants.Colors.errorRed
			serverAddressStatus.textColor = Constants.Colors.errorRed
			serverAddressStatus.text = Constants.Strings.invalidURL
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		if textField == serverAddressInput {
			join(textField)
		}
		
		return true
	}
	
}
