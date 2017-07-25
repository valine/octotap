//  Copyright Lukas Valine 2017
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

struct Constants {
	
	enum Server : String {
		case apiKey
		case address
		case streamUrl 
	}
	
	enum Printer {
		enum JogDistance {
			case x
			case y
			case z
		}
		
		enum Extruder {
			case extrusionAmount
			case flowRate
		}
	}
	
	enum TabelCellResuseIDs : String {
		case toolCell
		case filesCell
	}
	
	enum App : String {
		case firstLaunch
		case setupSuccessful
	}
	
	struct Strings {
		static let invalidURL = "The URL you entered is invalid".capitalized
		static let badConnections = "The OctoPrint server is not responding".capitalized
		static let successful = "Connection successful".capitalized
		
		static let bedToolName = "Bed"
		static let toolName = "Tool"
	}
	
	struct Colors {
		static let octotapGreen = #colorLiteral(red: 0.0974875365, green: 0.9805322289, blue: 0.4432027052, alpha: 1)
		static let errorRed = #colorLiteral(red: 0.9805322289, green: 0.4494236022, blue: 0.4543004445, alpha: 1)
		static let happyRed = #colorLiteral(red: 1, green: 0, blue: 0.2552101016, alpha: 1)
		static let linkBlue = #colorLiteral(red: 0.120020397, green: 0.5770391822, blue: 0.9824696183, alpha: 1)
		static let ashGrey = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
		static let almostBlack = #colorLiteral(red: 0.03166640236, green: 0.03166640236, blue: 0.03166640236, alpha: 1)
	}
	
	struct Dimensions {
		static let cellClosedHeight: CGFloat = 135
		static let cellOpenHeight: CGFloat = 230
		
		static let extrusionAmounts: Array<Float> = [2, 5, 10, 30]
	}
	
	
}
