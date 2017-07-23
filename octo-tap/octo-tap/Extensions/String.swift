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

import Foundation

extension String {
	
	func withHttp() -> String {
		if(self.hasPrefix("http://") || self.hasPrefix("https://")){
			return self
		}
		return "http://\(self)"
	}
	
	// SWIFT 4.0
//	func webSocketAddr() -> String {
//		if(self.hasPrefix("http://") || self.hasPrefix("https://")) {
//			return "ws\(self.substring(from: self.index(of: ":")!))"
//		}  else if (self.hasPrefix("ws://")) {
//			return self
//		} else {
//			return "ws://\(self)"
//		}
//	}
	

	// SWIFT 3.0
	func webSocketAddr() -> String {
		if self.hasPrefix("http://") {
			let index = self.index(self.startIndex, offsetBy: 4)
			return "ws\(self.substring(from: index))"

		}  else if  self.hasPrefix("https://"){
			let index = self.index(self.startIndex, offsetBy: 5)
			return "ws\(self.substring(from: index))"
		
		}else if (self.hasPrefix("ws://")) {
			return self

		} else {
			return "ws://\(self)"
		}
	}
	
}

