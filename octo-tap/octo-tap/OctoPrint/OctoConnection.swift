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

struct OctoConnection: Codable {
	
	struct Connected : Codable {
		var display_version: String?
		var apikey: String
		var branch: String?
		var plugin_hash: String?
		var config_hash: String?
		var version: String?
		var safe_mode: Bool?
		var debug: Bool?
	}
	
	let connected: Connected
}



