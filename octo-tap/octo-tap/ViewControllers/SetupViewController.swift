//  Copyright © 2017 Lukas Valine
//
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
	
	@IBOutlet weak var serverAddressInput: UITextField!
	
	// @IBOutlet weak var serverAddressSection: UITableViewSection!

	override func viewDidLoad() {
		super.viewDidLoad()
		serverAddressInput.delegate = self
		
		if let serverAddress =  UserDefaults.standard.string(forKey: Constants.Server.address.rawValue) {
			serverAddressInput.text = serverAddress
		}
	}
	
	@IBAction func join(_ sender: Any) {
		if let userInput = serverAddressInput.text {
			UserDefaults.standard.set(userInput.withHttp(), forKey: Constants.Server.address.rawValue)
		}
		let serverAddress = URL(string: UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)!)
		let octoprint = Octoprint()
		
		if let validURL = serverAddress {
			octoprint.getUIApiKey(address: validURL, completion: {(keyString: String?, error : Error?) -> Void in
				if (error != nil) {
					// BAD CONNECTION
					self.serverAddressInput.textColor =  Constants.Colors.errorRed
					//self.serverAddressSection.textColor = Constants.Colors.errorRed
					//self.serverAddressStatus.text = Constants.Strings.badConnections
				} else {
					// SUCESS
					self.serverAddressInput.textColor = Constants.Colors.octotapGreen
					//self.serverAddressStatus.textColor = Constants.Colors.octotapGreen
					//self.serverAddressStatus.text = Constants.Strings.successful
					
					UserDefaults.standard.set(keyString, forKey: Constants.Server.apiKey.rawValue)
					self.serverAddressInput.resignFirstResponder()
					
					let octoprintWs = OctoWebSockets.instance
					octoprintWs.openSocket(address: validURL)

					self.dismiss(animated: true, completion: nil)
				}
			})
			
		} else {
			// BAD INPUT
			serverAddressInput.textColor = Constants.Colors.errorRed
			//serverAddressStatus.textColor = Constants.Colors.errorRed
			//serverAddressStatus.text = Constants.Strings.invalidURL
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == serverAddressInput {
			join(textField)
		}
		return true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
}
