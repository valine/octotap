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

import Foundation
import SwiftWebSocket

class Octoprint {
	
	typealias OctoPrintResponse = (Data?, Error?) -> Void
	typealias StringResponse = (String?, Error?) -> Void
	typealias SettingsResponse = (OctoSettings?, Error?) -> Void
	typealias FilesResponse = (OctoFiles?, Error?) -> Void
	typealias TemperatureResponse = (Array<OctoWSFrame.Temp>?, Error?) -> Void
	
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
				do {
					if let returnedJSON = try JSONSerialization.jsonObject(with:  jsonString.data(using: .utf8)!, options: []) as? [String: Any] {
						
						let connection = OctoConnection(json: returnedJSON)
						
						if let successfulConnection = connection {
							print((successfulConnection.connected.apikey))
							completion((successfulConnection.connected.apikey), nil)
							
							socket.close()
						}
					}
				} catch {
					
				}
			}
			
				
// Swift 4 is so much better
//			if let jsonString = message as? String {
//				let decoder = JSONDecoder()
//				do {
//					let connection = try decoder.decode(OctoConnection.self, from: jsonString.data(using: .utf8)!)
//					print(connection.connected.apikey)
//					socket.close()
//					DispatchQueue.main.async(){
//						completion(connection.connected.apikey, nil)
//					}
//				} catch {
//					print("failed")
//				}
//			}
		}
	}
	
	func getFiles(address: URL, apiKey: String, completion : @escaping FilesResponse) {
		var request = URLRequest(url: address.appendingPathComponent("api/files"))
		request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
		let session = URLSession.shared
		let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
			
			if let retrievedData = data {
				do {
					if let returnedJSON = try JSONSerialization.jsonObject(with: retrievedData, options: []) as? [String: Any] {
						let files = OctoFiles(json: returnedJSON)
							
						if let parsedFiles = files {

							DispatchQueue.main.async(){
								completion(parsedFiles, error)
							}
						}
					}
				} catch {
					
				}
			} else {
				DispatchQueue.main.async(){
					completion(nil, error)
				}
			}
		})
		
		task.resume()
	}
	
	func getSettings(address: URL, apiKey: String, completion : @escaping SettingsResponse) {
		var request = URLRequest(url: address.appendingPathComponent("api/settings"))
		request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
		let session = URLSession.shared
		let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
			
			if let retrievedData = data {
				do {
					if let returnedJSON = try JSONSerialization.jsonObject(with: retrievedData, options: []) as? [String: Any] {
						let files = OctoSettings(json: returnedJSON)
						
						if let parsedFiles = files {
							
							DispatchQueue.main.async(){
								completion(parsedFiles, error)
							}
						}
					}
				} catch {
					
				}
			} else {
				DispatchQueue.main.async(){
					completion(nil, error)
				}
			}
		})
		
		task.resume()
	}
	
	func setTargetToolTemp(temps: ToolTemp, completion: @escaping OctoPrintResponse) {
		
		let url = URL(string: UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)!)
		let apiKey = UserDefaults.standard.string(forKey: Constants.Server.apiKey.rawValue)

		var request = URLRequest(url: url!.appendingPathComponent("/api/printer/tool"))
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: temps.toJSON(), options: .prettyPrinted)
			
			request.addValue(apiKey!, forHTTPHeaderField: "X-Api-Key")
			
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = jsonData
			
			let session = URLSession.shared
			let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
				DispatchQueue.main.async {
					completion(data, error)
				}
			})
			
			task.resume()
			
		} catch {
			
		}
	}
	
	func setTargetBedTemp(temps: BedTemp, completion: @escaping OctoPrintResponse) {
		
		let url = URL(string: UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)!)
		let apiKey = UserDefaults.standard.string(forKey: Constants.Server.apiKey.rawValue)
		
		var request = URLRequest(url: url!.appendingPathComponent("/api/printer/bed"))
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: temps.toJSON(), options: .prettyPrinted)
			
			request.addValue(apiKey!, forHTTPHeaderField: "X-Api-Key")
			
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = jsonData
			
			let session = URLSession.shared
			let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
				DispatchQueue.main.async {
					completion(data, error)
				}
			})
			
			task.resume()
			
		} catch {
			
		}
	}
	
	func jogPrintHead(jog: Jog, completion: @escaping OctoPrintResponse) {
		
		let url = URL(string: UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)!)
		let apiKey = UserDefaults.standard.string(forKey: Constants.Server.apiKey.rawValue)
		
		var request = URLRequest(url: url!.appendingPathComponent("/api/printer/printhead"))
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: jog.toJSON(), options: .prettyPrinted)
			
			request.addValue(apiKey!, forHTTPHeaderField: "X-Api-Key")
			
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = jsonData
			
			let session = URLSession.shared
			let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
				DispatchQueue.main.async {
					completion(data, error)
				}
			})
			
			task.resume()
			
		} catch {
			
		}
	}
	
	func fanOn() {
		let url = URL(string: UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)!)
		let apiKey = UserDefaults.standard.string(forKey: Constants.Server.apiKey.rawValue)
		var request = URLRequest(url: url!.appendingPathComponent("/api/printer/command"))
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: Fan().fanOnJSON(), options: .prettyPrinted)
			
			request.addValue(apiKey!, forHTTPHeaderField: "X-Api-Key")
			
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = jsonData
			
			let session = URLSession.shared
			let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
			})
			
			task.resume()
		} catch {}
	}
	
	func fanOff() {
		let url = URL(string: UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)!)
		let apiKey = UserDefaults.standard.string(forKey: Constants.Server.apiKey.rawValue)
		var request = URLRequest(url: url!.appendingPathComponent("/api/printer/command"))
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: Fan().fanOffJSON(), options: .prettyPrinted)
			
			request.addValue(apiKey!, forHTTPHeaderField: "X-Api-Key")
			
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = jsonData
			
			let session = URLSession.shared
			let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
			})
			
			task.resume()
		} catch {}
	}
	
	
	func homeXY() {
		let url = URL(string: UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)!)
		let apiKey = UserDefaults.standard.string(forKey: Constants.Server.apiKey.rawValue)
		var request = URLRequest(url: url!.appendingPathComponent("/api/printer/printhead"))
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: Home().homeXToJson(), options: .prettyPrinted)
			
			request.addValue(apiKey!, forHTTPHeaderField: "X-Api-Key")
			
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = jsonData
			
			let session = URLSession.shared
			let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
			})
			
			task.resume()
		} catch {}
	}
	
	func homeZ() {
		let url = URL(string: UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)!)
		let apiKey = UserDefaults.standard.string(forKey: Constants.Server.apiKey.rawValue)
		var request = URLRequest(url: url!.appendingPathComponent("/api/printer/printhead"))
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: Home().homeZToJson(), options: .prettyPrinted)
			
			request.addValue(apiKey!, forHTTPHeaderField: "X-Api-Key")
			
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = jsonData
			
			let session = URLSession.shared
			let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
			})
			
			task.resume()
		} catch {}
	}
	
	func motorsOff() {
		let url = URL(string: UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)!)
		let apiKey = UserDefaults.standard.string(forKey: Constants.Server.apiKey.rawValue)
		var request = URLRequest(url: url!.appendingPathComponent("/api/printer/command"))
		
		do {
			var json = [String: Any]()
			json["commands"] = ["M18"]
			
			let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
			
			request.addValue(apiKey!, forHTTPHeaderField: "X-Api-Key")
			
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = jsonData
			
			let session = URLSession.shared
			let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
			})
			
			task.resume()
		} catch {}
	}
	
	//{"commands":["M18"],"parameters":{}}
	
	func extrude(amount: Int, tool: Int) {
		let url = URL(string: UserDefaults.standard.string(forKey: Constants.Server.address.rawValue)!)
		let apiKey = UserDefaults.standard.string(forKey: Constants.Server.apiKey.rawValue)
		
		
		var requestSelect = URLRequest(url: url!.appendingPathComponent("/api/printer/tool"))
		do {
			var json = [String: Any]()
			json["tool"] = "tool\(tool)"
			json["command"] = "select"
			
			let jsonData = try JSONSerialization.data(withJSONObject:json, options: .prettyPrinted)
			
			requestSelect.addValue(apiKey!, forHTTPHeaderField: "X-Api-Key")
			
			requestSelect.httpMethod = "POST"
			requestSelect.setValue("application/json", forHTTPHeaderField: "Content-Type")
			requestSelect.httpBody = jsonData
			
			let session = URLSession.shared
			let task = session.dataTask(with: requestSelect, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
				
				var request = URLRequest(url: url!.appendingPathComponent("/api/printer/tool"))
				do {
					let extrude = Extrude(amount: amount, command: "extrude")
					let jsonData = try JSONSerialization.data(withJSONObject: extrude.toJson(), options: .prettyPrinted)
					
					request.addValue(apiKey!, forHTTPHeaderField: "X-Api-Key")
					
					request.httpMethod = "POST"
					request.setValue("application/json", forHTTPHeaderField: "Content-Type")
					request.httpBody = jsonData
					
					let session = URLSession.shared
					let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error : Error?) -> Void in
					})
					
					task.resume()
				} catch {}
			})
			
			task.resume()
		} catch {}
	}
	
	func extrude() {
	}
	
	func retract() {
	}
	
}
