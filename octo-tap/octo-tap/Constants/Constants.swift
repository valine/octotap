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
		static let octotapGreen = #colorLiteral(red: 0.3144616787, green: 0.6020978744, blue: 0.2477480187, alpha: 1)
		static let errorRed = #colorLiteral(red: 0.7681432424, green: 0.1994044624, blue: 0.192549982, alpha: 1)
		static let almostBlack = #colorLiteral(red: 0.04440529638, green: 0.04926400222, blue: 0.05597636421, alpha: 1)
		static let linkBlue = #colorLiteral(red: 0.3061920226, green: 0.4673921935, blue: 0.8344106916, alpha: 1)
	}
	
	
}
