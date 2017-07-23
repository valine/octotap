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

}
