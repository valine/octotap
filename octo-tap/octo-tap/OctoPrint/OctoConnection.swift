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

// Example frame from api
//
//{"connected":
//	{"display_version": "1.3.4 (master branch)",
//	 "apikey": "09A1109E60D84613BDCDCE798389CC0A",
//	 "branch": "master",
//	 "plugin_hash": "50ce1f261f46b79765660a44012bf7ed",
//	 "config_hash": "343d36f27c4bb8eb7a37f418bd4db529",
//	 "version": "1.3.4",
//	 "safe_mode": false,
//	 "debug": false}
//}

import Foundation

struct OctoConnection {
	
	init?(json: [String: Any]) {
		if let sub: [String: Any] = json["connected"] as? [String : Any] {
		guard let displayVersion = sub["display_version"] as? String,
			let apikey = sub["apikey"] as? String,
			let branch = sub["branch"] as? String,
			let pluglinHash = sub["plugin_hash"] as? String else {
				return nil
			}
		self.connected = Connected(
			display_version: displayVersion,
			apikey: apikey,
			branch: branch,
			plugin_hash: pluglinHash,
			config_hash: nil,
			version: nil,
			safe_mode: nil,
			debug: nil)
		} else {
			return nil
		}


	}
	
	struct Connected {
		var display_version: String?
		var apikey: String
		var branch: String?
		var plugin_hash: String?
		var config_hash: String?
		var version: String?
		var safe_mode: Bool?
		var debug: Bool?
	}
	
	var connected: Connected
}


//	{
//	"files": [
//	{
//	"name": "whistle_v2.gcode",
//	"path": "whistle_v2.gcode",
//	"type": "machinecode",
//	"typePath": ["machinecode", "gcode"],
//	"hash": "...",
//	"size": 1468987,
//	"date": 1378847754,
//	"origin": "local",
//	"refs": {
//	"resource": "http://example.com/api/files/local/whistle_v2.gcode",
//	"download": "http://example.com/downloads/files/local/whistle_v2.gcode"
//	},
//	"gcodeAnalysis": {
//		"estimatedPrintTime": 1188,
//		"filament": {
//			"length": 810,
//			"volume": 5.36
//		}
//	},
//	"print": {
//	"failure": 4,
//	"success": 23,
//	"last": {
//	"date": 1387144346,
//	"success": true
//	}
//	}
//	},
//	{
//	"name": "whistle_.gco",
//	"path": "whistle_.gco",
//	"type": "machinecode",
//	"typePath": ["machinecode", "gcode"],
//	"origin": "sdcard",
//	"refs": {
//	"resource": "http://example.com/api/files/sdcard/whistle_.gco"
//	}
//	},
//	{
//	"name": "folderA",
//	"path": "folderA",
//	"type": "folder",
//	"typePath": ["folder"],
//	"children": [],
//	"size": 1334
//	}
//	],
//	"free": "3.2GB"
//	}
//

struct OctoFiles {
	
	init?(json: [String: Any]) {
		
		files = [File]()
		
		if let jsonFiles = json["files"] as? Array<[String: Any]> {
			
			for jsonFile in jsonFiles{
				
				var ref: File.Ref = File.Ref(resource: nil, download: nil)
				
				if let jsonRef = jsonFile["refs"] as? [String: Any] {
					
					if let resource = jsonRef["resource"] as? String {
						ref.resource = resource
					}
					
					if let download = jsonRef["download"] as? String {
						ref.download = download
					}
				}
				
				
				
				var filament = File.GCodeAnalysis.Filament(
					length: nil,
					volume: nil)
				
				
				var gcodeAnalysis = File.GCodeAnalysis(estimatedPrintTime: nil, filament: filament)
				
				if let jsonGcodeAnalysis = jsonFile["gcodeAnalysis"] as? [String: Any] {
					
					let jsonFilament = jsonGcodeAnalysis["filament"] as! [String: Any]
					
					if let length = jsonFilament["length"] as? Int {
						filament.length = length
					}
					
					if let volume = jsonFilament["volume"] as? Float {
						filament.volume = volume
					}
					
					gcodeAnalysis.estimatedPrintTime = jsonGcodeAnalysis["estimatedPrintTime"] as? Int
				}
				
			
				
				var print = File.Print(failure: nil, success: nil, last: nil)
				
				if let printJson = json["print"] as? [String: Any] {
				
					let lastJson = printJson["last"] as! [String: Any]
					let last = File.Print.Last(date: lastJson["date"] as? Int64, success: lastJson["success"] as? Bool)
					print = File.Print(
						failure: printJson["failure"] as? Int,
						success: printJson["success"] as? Int,
						last: last)
				}
				
				var file = File(name: nil,
							 path: nil,
							 type: nil,
							 typePath: nil,
							 hash: nil,
							 size: nil,
							 date: nil,
							 origin: nil,
							 ref: ref,
							 gcodeAnalysis: gcodeAnalysis,
							 print: print)
				
				if let name =  jsonFile["name"] as? String {
					file.name = name
				}
				
				if let path = jsonFile["path"] as? String {
					file.path = path
				}
				
				if let type = jsonFile["type"] as? String {
					file.type = type
				}
				
				if let hash = jsonFile["hash"] as? String {
					file.hash = hash
				}
				
				if let size = jsonFile["size"] as? Int {
					file.size = size
				}
				
				if let date = jsonFile["date"] as? Int64 {
					file.date = date
				}
				
				if let origin = jsonFile["origin"] as? String {
					file.origin = origin
				}
				
				files.append(file)
			}
		}
	
	
		free = json["free"] as! Int
		
	}
	
	var files: Array<File>
	var free: Int?
	
	struct File {
		
		var name: String?
		var path: String?
		var type: String?
		var typePath: Array<String>?
		var hash: String?
		var size: Int?
		var date: Int64?
		var origin: String?
		var ref: Ref?
		var gcodeAnalysis: GCodeAnalysis?
		var print: Print?
		
		struct Ref {
			var resource: String?
			var download: String?
		}
		
		struct GCodeAnalysis {
			var estimatedPrintTime: Int?
			var filament: Filament?
			
			struct Filament {
				var length: Int?
				var volume: Float?
			}
		}
		
		struct Print {
			var failure: Int?
			var success: Int?
			var last: Last?
			
			struct Last {
				var date: Int64?
				var success: Bool?
			}
		}
	}
	
}



