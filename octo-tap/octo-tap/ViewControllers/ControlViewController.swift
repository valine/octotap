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
import MjpegStreamingKit


class ControllerViewController: UIViewController {
	
	var jogDistance: Float = Float(1)
	
	@IBOutlet weak var forwardButton: UIButton!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var leftButton: UIButton!
	@IBOutlet weak var rightButton: UIButton!
	@IBOutlet weak var homeXYButton: UIButton!
	
	@IBOutlet weak var upwardButton: UIButton!
	@IBOutlet weak var downwardButton: UIButton!

	@IBOutlet weak var homeZButton: UIButton!
	@IBOutlet weak var fanOnButton: UIButton!
	@IBOutlet weak var fanOffButton: UIButton!
	
	@IBOutlet weak var motorsOffButton: UIButton!
	var streamingUrl: URL?
	
	var streamingController: MjpegStreamingController?
	

	var octoprint: Octoprint?
	@IBOutlet weak var webcam: UIImageView!
	override func viewDidLoad() {
		
		octoprint = Octoprint()
		
		forwardButton.layer.cornerRadius = forwardButton.frame.width / 2
		backButton.layer.cornerRadius = backButton.frame.width / 2
		leftButton.layer.cornerRadius = leftButton.frame.width / 2
		rightButton.layer.cornerRadius = rightButton.frame.width / 2
		homeXYButton.layer.cornerRadius = homeXYButton.frame.width / 2
		
		upwardButton.layer.cornerRadius = upwardButton.frame.width / 2
		downwardButton.layer.cornerRadius = downwardButton.frame.width / 2
		homeZButton.layer.cornerRadius = homeZButton.frame.width / 2
		
		fanOffButton.layer.cornerRadius = 5
		fanOnButton.layer.cornerRadius = 5
		motorsOffButton.layer.cornerRadius = 5
		
		webcam.layer.borderWidth = 1
		webcam.layer.borderColor = Constants.Colors.ashGrey.cgColor
		let address = URL(string: UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)!)
		let apikey =  UserDefaults.standard.string(forKey: Constants.Server.apiKey.rawValue)
		octoprint?.getSettings(address: address!, apiKey: apikey!, completion: {(response: OctoSettings?, error: Error?) in
			self.streamingUrl = URL(string: (response?.webcam.streamUrl)!)!
			
			self.streamingController = MjpegStreamingController(imageView: self.webcam)
			self.streamingController?.play(url: self.streamingUrl!)
		
		})

	}
	
	override func viewDidAppear(_ animated: Bool) {
		self.streamingController = MjpegStreamingController(imageView: self.webcam)
		if let unwrappedURL = self.streamingUrl {
			self.streamingController?.play(url:unwrappedURL)
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		streamingController?.stop()
	}
	
	@IBAction func forwardTapped(_ sender: Any) {
		octoprint?.jogPrintHead(jog: Jog(command: "jog", x: nil, y: jogDistance, z: nil), completion: {(data: Data?, error:Error?) in })
	}

	@IBAction func backwardTapped(_ sender: Any) {
		octoprint?.jogPrintHead(jog: Jog(command: "jog", x: nil, y: -jogDistance, z: nil), completion: {(data: Data?, error:Error?) in })
	}
	
	@IBAction func leftTapped(_ sender: Any) {
		octoprint?.jogPrintHead(jog: Jog(command: "jog", x: -jogDistance, y: nil, z: nil), completion: {(data: Data?, error:Error?) in })
	}
	
	@IBAction func rightTapped(_ sender: Any) {
		octoprint?.jogPrintHead(jog: Jog(command: "jog", x: jogDistance, y: nil, z: nil), completion: {(data: Data?, error:Error?) in })
	}

	
	@IBAction func upTapped(_ sender: Any) {
			octoprint?.jogPrintHead(jog: Jog(command: "jog", x: nil, y: nil, z: jogDistance), completion: {(data: Data?, error:Error?) in })
	}

	@IBAction func downTapped(_ sender: Any) {
			octoprint?.jogPrintHead(jog: Jog(command: "jog", x: nil, y: nil, z: -jogDistance), completion: {(data: Data?, error:Error?) in })
		
	}
	
	@IBAction func xyHomeTapped(_ sender: Any) {
		
		octoprint?.homeXY()
	}
	
	@IBAction func zHomeTapped(_ sender: Any) {
		octoprint?.homeZ()
	}

	@IBAction func fanOn(_ sender: Any) {
		octoprint?.fanOn()
	}

	@IBAction func fanOff(_ sender: Any) {
		octoprint?.fanOff()
	}
	
	@IBAction func motorsOff(_ sender: Any) {
		octoprint?.motorsOff()
	}
	@IBAction func jogDistanceSet(_ sender: Any) {
		
		let control = sender as! UISegmentedControl
		jogDistance = Float(control.titleForSegment(at: control.selectedSegmentIndex)!)!
	}

}

