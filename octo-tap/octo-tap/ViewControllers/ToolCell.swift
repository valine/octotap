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

class ToolCell: UITableViewCell {
	
	var item: Int? 
	@IBOutlet weak var extrudeButton: UIButton!
	@IBOutlet weak var retractButton: UIButton!
		
	@IBOutlet weak var targetTemperature: UITextField!
	@IBOutlet weak var actualTemperature: UILabel!
	
	@IBOutlet weak var displayMoreBar: UIView!
	@IBOutlet weak var displayDetails: UIView!
	
	@IBOutlet weak var displayMoreDots: UIImageView!
	@IBOutlet weak var toolNameLabel: UILabel!
	@IBOutlet weak var currentTempLabel: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		extrudeButton.layer.cornerRadius = extrudeButton.frame.width / 2
		retractButton.layer.cornerRadius = extrudeButton.frame.width / 2
		
		targetTemperature.layer.cornerRadius = 10
		targetTemperature.layer.borderWidth = 1.5
		targetTemperature.layer.borderColor = Constants.Colors.ashGrey.cgColor
		addDoneButtonOnKeyboard()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func hideExtruderControls() {
		extrudeButton.isHidden = true
		retractButton.isHidden = true
		displayMoreDots.isHidden = true
		displayMoreBar.backgroundColor = Constants.Colors.almostBlack
	}
	
	func addDoneButtonOnKeyboard() {
		let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
		doneToolbar.barStyle       = UIBarStyle.blackOpaque
		
		let cancel: UIBarButtonItem  = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelButtonAction))
		cancel.tintColor = Constants.Colors.errorRed
		let off: UIBarButtonItem   = UIBarButtonItem(title: "Off", style: UIBarButtonItemStyle.plain, target: self, action: #selector(offButtonAction))
		off.tintColor = .lightGray
		
		let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		
		let space                  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
		space.width = 20
		let done: UIBarButtonItem  = UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
		
		var items = [UIBarButtonItem]()
		items.append(cancel)
		items.append(flexSpace)
		items.append(off)
		items.append(space)
		items.append(done)
		
		doneToolbar.items = items
		doneToolbar.sizeToFit()
		self.targetTemperature.inputAccessoryView = doneToolbar
	}
	
	func doneButtonAction() {
		if targetTemperature.text != "" {
			var tempsToSend = ToolTemp(command: "target", targets: nil)
			let value = Float(targetTemperature.text!)
			let octoprint = Octoprint()
			
			if let unwrappedItem = item {
				switch unwrappedItem {
				case 0:
					let targets = ToolTemp.Targets(tool0: value, tool1: nil, bed: nil)
					tempsToSend.targets = targets
					octoprint.setTargetToolTemp(temps: tempsToSend, completion: {(data: Data?, error: Error?) in
						self.targetTemperature.text = ""
					})
					
				case 1:
					let targets = ToolTemp.Targets(tool0: nil, tool1: value, bed: nil)
					tempsToSend.targets = targets
					octoprint.setTargetToolTemp(temps: tempsToSend, completion: {(data: Data?, error: Error?) in
						self.targetTemperature.text = ""
					})
					
				case 2:
					let bedTempToSend = BedTemp(command: "target", target: value)
					
					octoprint.setTargetBedTemp(temps: bedTempToSend, completion: {(data: Data?, error: Error?) in
						self.targetTemperature.text = ""
					})
				default:
					print("error sending temp")
				}
			}
		}
		
		self.targetTemperature.resignFirstResponder()
	}
	
	func offButtonAction() {
		self.targetTemperature.text = ""
		self.targetTemperature.resignFirstResponder()
		
		var tempsToSend = ToolTemp(command: "target", targets: nil)
		let octoprint = Octoprint()
		
		if let unwrappedItem = item {
			switch unwrappedItem {
			case 0:
				let targets = ToolTemp.Targets(tool0: 0, tool1: nil, bed: nil)
				tempsToSend.targets = targets
				octoprint.setTargetToolTemp(temps: tempsToSend, completion: {(data: Data?, error: Error?) in
					self.targetTemperature.text = ""
				})
				
			case 1:
				let targets = ToolTemp.Targets(tool0: nil, tool1: 0, bed: nil)
				tempsToSend.targets = targets
				octoprint.setTargetToolTemp(temps: tempsToSend, completion: {(data: Data?, error: Error?) in
					self.targetTemperature.text = ""
				})
				
			case 2:
				let bedTempToSend = BedTemp(command: "target", target: 0)
				
				octoprint.setTargetBedTemp(temps: bedTempToSend, completion: {(data: Data?, error: Error?) in
					self.targetTemperature.text = ""
				})
			default:
				print("error sending temp")
			}
		}

	}

	
	func cancelButtonAction() {
		self.targetTemperature.text = ""
		self.targetTemperature.resignFirstResponder()
	}

}
