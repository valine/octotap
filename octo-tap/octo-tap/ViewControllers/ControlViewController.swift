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
import MjpegStreamingKit


class ControllerViewController: UIViewController {
	
	@IBOutlet weak var forwardButton: UIButton!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var leftButton: UIButton!
	@IBOutlet weak var rightButton: UIButton!
	@IBOutlet weak var homeXYButton: UIButton!
	
	@IBOutlet weak var upwardButton: UIButton!
	@IBOutlet weak var downwardButton: UIButton!
	@IBOutlet weak var homeZButton: UIButton!
	
	@IBOutlet weak var webcam: UIImageView!
	override func viewDidLoad() {
		
		forwardButton.layer.cornerRadius = forwardButton.frame.width / 2
		backButton.layer.cornerRadius = backButton.frame.width / 2
		leftButton.layer.cornerRadius = leftButton.frame.width / 2
		rightButton.layer.cornerRadius = rightButton.frame.width / 2
		homeXYButton.layer.cornerRadius = homeXYButton.frame.width / 2
		
		upwardButton.layer.cornerRadius = upwardButton.frame.width / 2
		downwardButton.layer.cornerRadius = downwardButton.frame.width / 2
		homeZButton.layer.cornerRadius = homeZButton.frame.width / 2
		
		let octoprint = Octoprint()
		let address = URL(string: UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)!)
		let apikey =  UserDefaults.standard.string(forKey: Constants.Server.apiKey.rawValue)
		octoprint.getSettings(address: address!, apiKey: apikey!, completion: {(response: OctoSettings?, error: Error?) in
			let url = URL(string: (response?.webcam.streamUrl)!)
			
			let streamingController = MjpegStreamingController(imageView: self.webcam)
			streamingController.play(url: url!)
		
		})

	}
	
}
