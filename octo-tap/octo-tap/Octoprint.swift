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

// OctoPrint rest api requests are made here
class Octoprint {
	typealias OctoPrintResponse = (Data?, Error?) -> Void
	
	func httpGetRequest(url: URL, completion : @escaping OctoPrintResponse) {
		let request = URLRequest(url: url)
		let session = URLSession.shared
		let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
			completion(data, error)
		})
		
		task.resume()
	}
	
	func httpPostRequest(url: URL, data: Data, completion: @escaping OctoPrintResponse) {
		var request = URLRequest(url: url)
		
		request.httpMethod = "POST"
	 	request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = data
		
		let session = URLSession.shared
		let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
			DispatchQueue.main.async {
				completion(data, error)
			}
		})
		
		task.resume()
	}
	
	func extrude() {
	}
	
	func retract() {
	}
	
}
