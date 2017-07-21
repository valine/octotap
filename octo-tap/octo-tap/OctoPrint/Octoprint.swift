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
import SwiftWebSocket

class Octoprint {
	
	typealias OctoPrintResponse = (Data?, Error?) -> Void
	typealias StringResponse = (String?, Error?) -> Void
	
	func getUIApiKey(address: URL, completion : @escaping StringResponse) {
		
		let url = "\(address.absoluteString.webSocketAddr())/sockjs/websocket"
		
		let socket = WebSocket(url)
		socket.event.open = {
			print("OctoPrint socket opened")
		}
		
		socket.event.error = {(error: Error) in
			DispatchQueue.main.async(){
				completion(nil, error)
			}
		}
		
		socket.event.message = { message in
			if let jsonString = message as? String {
				let decoder = JSONDecoder()
				do {
					let connection = try decoder.decode(OctoConnection.self, from: jsonString.data(using: .utf8)!)
					print(connection.connected.apikey)
					socket.close()
					DispatchQueue.main.async(){
						completion(connection.connected.apikey, nil)
					}
				} catch {
					print("failed")
				}
			}
		}
	}
	
	func getFiles(address: URL, apiKey: String, completion : @escaping StringResponse) {
		var request = URLRequest(url: address.appendingPathComponent("api/files"))
		request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
		let session = URLSession.shared
		let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
			
			if let retrievedData = data {
				let response = String(data: retrievedData, encoding: String.Encoding.utf8) as String!
				DispatchQueue.main.async(){
					completion(response, error)
				}
			} else {
				DispatchQueue.main.async(){
					completion(nil, error)
				}
			}
		})
		
		task.resume()
	}
	
	func httpGetRequest(url: URL, completion : @escaping OctoPrintResponse) {
		
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