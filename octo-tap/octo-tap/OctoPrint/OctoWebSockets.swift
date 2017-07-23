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

class OctoWebSockets {
	
	static let instance = OctoWebSockets()
	var delegate: OctoPrintDelegate?

	
	var socket: WebSocket?
	func openSocket(address: URL) {
	
		let url = "\(address.absoluteString.webSocketAddr())/sockjs/websocket"
		socket = WebSocket(url: URL(string: url)!)

		socket?.event.open = {
			print("OctoPrint socket opened singleton")
		}
	
		socket?.event.message = { message in
			if let jsonString = message as? String {
				do {
					if let returnedJSON = try JSONSerialization.jsonObject(with:  jsonString.data(using: .utf8)!, options: []) as? [String: Any] {
						
						if(self.delegate != nil) {
							let current = OctoWSFrame(json: returnedJSON)
							
							if current != nil {
								if current?.current != nil {
									if (current?.current?.temps?.count)! > 0{
										DispatchQueue.main.async(){
											self.delegate?.temperatureUpdate(temp: (current?.current?.temps)!)
										}
									}
								}
							}
						}
					}
				} catch {
					
				}
			}
		}
	}
}


protocol OctoPrintDelegate {
	
	func temperatureUpdate(temp:Array<OctoWSFrame.Temp>)
	
}


