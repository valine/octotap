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
				
				var printO = File.Print(failure: nil, success: nil, last: nil)
				
				if let printJson = jsonFile["prints"] as? [String: Any] {
				
					let lastJson = printJson["last"] as! [String: Any]
					let last = File.Print.Last(date: lastJson["date"] as? Int64, success: lastJson["success"] as? Bool)
					printO.failure = printJson["failure"] as? Int
					printO.success = printJson["success"] as? Int
					printO.last = last
						
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
							 print: printO)
				
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
	
		if let free = json["free"] as? Int {
			self.free = free
		}
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

struct OctoWSFrame {
	
	init?(json: [String: Any]) {
		
		
		if let jCurrent = json["current"] as? [String: Any] {
			current = Current(temps: nil)
			
			var temps = [Temp]()

			
			if let jTemps = jCurrent["temps"] as? Array<[String: Any]> {
				for jTemp in jTemps {
					var temp = Temp(tool0: nil, tool1: nil, bed: nil, time: nil)
					
					var tool0 = Temp.Tool(actual: nil, target: nil)
					if let jTool0 = jTemp["tool0"] as? [String: Any] {
						
						tool0.actual = jTool0["actual"] as? Float
						tool0.target = jTool0["target"] as? Float
						
						temp.tool0 = tool0
					}
					
					var tool1 = Temp.Tool(actual: nil, target: nil)
					if let jTool1 = jTemp["tool1"] as? [String: Any] {
						
						tool1.actual = jTool1["actual"] as? Float
						tool1.target = jTool1["target"] as? Float
						
						temp.tool1 = tool1
					}
					
					var bed = Temp.Tool(actual: nil, target: nil)
					if let jBed = jTemp["bed"] as? [String: Any] {
						
						bed.actual = jBed["actual"] as? Float
						bed.target = jBed["target"] as? Float

						temp.bed = bed
					}
					
					if let time = jTemp["time"] as? Int64 {
						temp.time = time;
					}
					
					temps.append(temp)
				}
			}
			
			current?.temps = temps
		}
	}
	
	
	var current: Current?
	
	struct Current {
		var temps: Array<Temp>?
	}
	
	struct Temp {
		var tool0: Tool?
		var tool1: Tool?
		var bed: Tool?
		var time: Int64?
		
		struct Tool {
			var actual: Float?
			var target: Float?
		}
	}
}

//
//"current":{
//	"logs": ["Send: M105", "Recv: ok T:25.5 /0.0 B:24.4 /0.0 T0:25.5 /0.0 T1:39.0 /0.0 @:0 B@:0"],
//	"offsets": {},
//	"serverTime": 1500784190.188776,
//	"busyFiles": [],
//	"messages": ["ok T:25.5 /0.0 B:24.4 /0.0 T0:25.5 /0.0 T1:39.0 /0.0 @:0 B@:0"],
//	"job": {
//		"file": {"origin": "local", "path": "vna2.gcode", "date": 1500267303, "name": "vna2.gcode", "size": 1229879},
//		"estimatedPrintTime": 1070.1013801327497,
//		"averagePrintTime": 1755.2051520347595,
//		"filament": {
//			"tool0": {"volume": 8.729912310853965, "length": 3629.475779999869}},
//			"lastPrintTime": 1307.442785024643
//	},
//		
//	"temps": [{
//		"tool0": {
//			"actual": 25.5, "target": 0.0
//		},
//		"bed": {
//			"actual": 24.4,
//			"target": 0.0
//		},
//		"tool1": {
//			"actual": 39.0,
//			"target": 0.0
//		},
//		"time": 1500784190
//	}],
//	"state": {
//		"text": "Operational",
//		"flags": {
//			"operational": true,
//			"paused": false,
//			"printing": false,
//			"sdReady": true,
//			"error": false,
//			"ready": true,
//			"closedOrError": false
//		}
//	},
//	"currentZ": 62.7,
//	"progress": {
//		"completion": 100,
//		"printTimeLeft": 0,
//		"printTime": 1307,
//		"filepos": 1229879
//	}
//}


struct OctoSettings {
	
	var webcam = Webcam(bitrate: nil, ffmpegPath: nil, ffmpegThreads: nil, flipH: nil, flipV: nil, rotate90: nil, snapshotUrl: nil, streamRatio: nil, streamUrl: nil, watermark: nil)
	
	
	init?(json: [String: Any]) {

		if let jWebcam = json["webcam"] as? [String: Any] {
			if let bitrate = jWebcam["bitrate"] as? String {
				webcam.bitrate = bitrate
			}
			
			if let ffmpegPath = jWebcam["ffmpegPath"] as? String {
				webcam.ffmpegPath = ffmpegPath
			}
			
			if let ffmpegThreads = jWebcam["ffmpegThreads"] as? Int {
				webcam.ffmpegThreads = ffmpegThreads
			}
			
			if let flipH = jWebcam["flipH"] as? Bool {
				webcam.flipH = flipH
			}
			
			if let flipV = jWebcam["flipV"] as? Bool {
				webcam.flipV = flipV
			}
			
			if let rotate90 = jWebcam["rotate90"] as? Bool {
				webcam.rotate90 = rotate90
			}
			
			if let snapshotUrl = jWebcam["snapshotUrl"] as? String {
				webcam.snapshotUrl = snapshotUrl
			}
			
			if let streamRatio = jWebcam["streamRatio"] as? String {
				webcam.streamRatio = streamRatio
			}
			
			if let streamUrl = jWebcam["streamUrl"] as? String {
				webcam.streamUrl = streamUrl
			}
			
			if let watermark = jWebcam["watermark"] as? Bool {
				webcam.watermark = watermark
			}
		}
	}
	
	
	struct Webcam {
		var bitrate: String?
		var ffmpegPath: String?
		var ffmpegThreads: Int?
		var flipH: Bool?
		var flipV: Bool?
		var rotate90: Bool?
		var snapshotUrl: String?
		var streamRatio: String?
		var streamUrl: String?
		var watermark: Bool?
	}
	
	
}


//
//"webcam": {
//	"bitrate": "5000k",
//	"ffmpegPath": "/usr/bin/avconv",
//	"ffmpegThreads": 1,
//	"flipH": false,
//	"flipV": false,
//	"rotate90": false,
//	"snapshotUrl": "http://127.0.0.1:8080/?action=snapshot",
//	"streamRatio": "16:9",
//	"streamUrl": "http://10.0.1.92:8080/?action=stream",
//	"watermark": false
//}


struct ToolTemp {
	
	var command: String?
	var targets: Targets?
	
	struct Targets {
		var tool0: Float?
		var tool1: Float?
		var bed: Float?
	}
	func toJSON() -> [String: Any]{
		var json = [String: Any]()
		
		if let unwrappedCommand = command {
			json["command"] = unwrappedCommand
		}
		
		if let unwrappedTargets = targets {
			var targetsJson = [String: Any]()
			
			if let unwrappedTool0 = unwrappedTargets.tool0 {
				targetsJson["tool0"] = unwrappedTool0
			}
			
			if let unwrappedTool1 = unwrappedTargets.tool1 {
				targetsJson["tool1"] = unwrappedTool1
			}

			json["targets"] = targetsJson
		}
	
		return json
	}
}


struct BedTemp {
	
	var command: String?
	var target: Float?
	
	func toJSON() -> [String: Any]{
		var json = [String: Any]()
		
		if let unwrappedCommand = command {
			json["command"] = unwrappedCommand
		}
			
		if let unwrappedBed = target {
			json["target"] = unwrappedBed
		}
		
		return json
	}
}

//
//	POST /api/printer/tool HTTP/1.1
//	Host: example.com
//	Content-Type: application/json
//	X-Api-Key: abcdef...
//
//	{
//	"command": "target",
//	"targets": {
//	"tool0": 220,
//	"tool1": 205
//	}
//	}

struct Jog {
	var command: String?
	var x: Float?
	var y: Float?
	var z: Float?
	
	func toJSON() -> [String: Any] {
		var json = [String: Any]()
		
		if let unwrapped = command {
			json["command"] = unwrapped
		}
		
		if let xUnwrapped = x {
			json["x"] = xUnwrapped
		}
		if let yUnwrapped = y {
			json["y"] = yUnwrapped
		}
		if let zUnwrapped = z {
			json["z"] = zUnwrapped
		}
		
		return json
	}
}

struct Fan {

	func fanOnJSON() -> [String: Any] {
		var json = [String: Any]()
		
		json["commands"] = ["M106 S255"]
		
		return json;
	}
	
	func fanOffJSON() -> [String: Any] {
		var json = [String: Any]()
		
		json["commands"] = ["M106 S0"]
		
		return json;
	}


}

//		POST /api/printer/printhead HTTP/1.1
//		Host: example.com
//		Content-Type: application/json
//		X-Api-Key: abcdef...
//
//		{
//			"command": "home",
//			"axes": ["x", "y"]
//		}

struct Home {
	
	func homeXToJson() -> [String: Any] {
		var json = [String: Any]()
		json["command"] = "home"
		json["axes"] = ["x", "y"]
		
		return json
	}
	
	func homeZToJson() -> [String: Any] {
		var json = [String: Any]()
		json["command"] = "home"
		json["axes"] = ["z"]
		
		return json
	}
	
}

struct Extrude {
	
	var amount: Int?
	var command: String?
	
	
	func toJson() -> [String: Any] {
		var json = [String: Any]()
		json["command"] = command
		
		if let unwrapped = amount {
			json["amount"] = unwrapped
		}
		
		return json
	}
//	
//	POST /api/printer/tool HTTP/1.1
//	Host: example.com
//	Content-Type: application/json
//	X-Api-Key: abcdef...
//	
//	{
//	"command": "extrude",
//	"amount": 5
//	}
	
}

//{"commands":["M106 S0"],"parameters":{}}

//POST /api/printer/printhead HTTP/1.1
//Host: example.com
//Content-Type: application/json
//X-Api-Key: abcdef...
//
//{
//	"command": "jog",
//	"x": 10,
//	"y": -5,
//	"z": 0.02
//}

