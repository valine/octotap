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
import Charts

class TemperatureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OctoPrintDelegate {
	
	@IBOutlet weak var toolTableView: UITableView!

	var temperatures:Array<OctoWSFrame.Temp>?
	var cellsOpen =  Array(repeating: Constants.Dimensions.cellClosedHeight, count: 3)

	//@IBOutlet weak var temperatureChart: TemperatureChart!
	override func viewDidLoad() {
		super.viewDidLoad()
		toolTableView.delegate = self
		toolTableView.dataSource = self
		
		let octoprintWs = OctoWebSockets.instance
		octoprintWs.delegate = self
		
//		let populationData :[Int : Double] = [
//			1990 : 123456.0,
//			2000 : 233456.0,
//			2010 : 343456.0
//		]
//		
//		let ySeries = populationData.map { x, y in
//			return ChartDataEntry(x: Double(x), y: y)
//		}
//		
//		let data = LineChartData()
//		let dataset = LineChartDataSet(values: ySeries, label: "Hello")
//		dataset.colors = [NSUIColor.red]
//		data.addDataSet(dataset)
//		
//		temperatureChart.data = data
//		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//TODO pull number of tools
		return 3
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		var cellHeight: CGFloat = 118

		cellHeight = cellsOpen[indexPath.item]
		
		return cellHeight;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:ToolCell = self.toolTableView.dequeueReusableCell(withIdentifier: Constants.TabelCellResuseIDs.toolCell.rawValue) as! ToolCell!
		
		if (indexPath.item == indexPath.endIndex) {
			cell.hideExtruderControls()
			cell.toolNameLabel.text = Constants.Strings.bedToolName
		} else {
			cell.toolNameLabel.text = "\(Constants.Strings.toolName) \(indexPath.item)"
			let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
			tap.minimumPressDuration = 0
			cell.displayDetails.tag = indexPath.item
			cell.displayDetails.addGestureRecognizer(tap)
		}

		cell.item = indexPath.item
		if let temperaturesSet = temperatures {
			
			switch indexPath.item {
			case 0:
				cell.actualTemperature.text = "\((temperaturesSet[0].tool0!.actual)!)°C"
			case 1:
				cell.actualTemperature.text = "\((temperaturesSet[0].tool1!.actual)!)°C"
			case 2:
				cell.actualTemperature.text = "\((temperaturesSet[0].bed!.actual)!)°C"
			default:
				print("error setting temp label")
			}
		}
		
		return cell
	}
	
	func tapHandler(gesture: UITapGestureRecognizer) {
		
		let tag = gesture.view?.tag
		if  gesture.state == .ended {
			
			let expandedHeight: CGFloat = Constants.Dimensions.cellOpenHeight
			toolTableView.beginUpdates()
			
			if cellsOpen[tag!] == expandedHeight {
				cellsOpen[tag!] = Constants.Dimensions.cellClosedHeight
			} else {
				cellsOpen[tag!] = Constants.Dimensions.cellOpenHeight
			}
			
			toolTableView.endUpdates()
		}
	}
	
	func refresh() {
		
		if let temperaturesSet = temperatures {
			
			if let tool0 = toolTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? ToolCell {
				
				tool0.actualTemperature.text = "\((temperaturesSet[0].tool0!.actual)!)°C"
				
				if (temperaturesSet[0].tool0!.target)! == 0 {
					tool0.targetTemperature.placeholder = "Off"
				} else {
					tool0.targetTemperature.placeholder = "\((temperaturesSet[0].tool0!.target)!)°C"
				}
			}
			
			if let tool1 = toolTableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? ToolCell {
				tool1.actualTemperature.text = "\((temperaturesSet[0].tool1!.actual)!)°C"
				
				if (temperaturesSet[0].tool1!.target)! == 0 {
					tool1.targetTemperature.placeholder = "Off"
				} else {
					tool1.targetTemperature.placeholder = "\((temperaturesSet[0].tool1!.target)!)°C"
				}

			}
			
			if let bed = toolTableView.cellForRow(at: IndexPath(item: 2, section: 0)) as? ToolCell {
				bed.actualTemperature.text = "\((temperaturesSet[0].bed!.actual)!)°C"
				
				
				if (temperaturesSet[0].bed!.target)! == 0 {
					bed.targetTemperature.placeholder = "Off"
				} else {
					bed.targetTemperature.placeholder = "\((temperaturesSet[0].bed!.target)!)°C"
				}
			}
		}
	}

	func temperatureUpdate(temp: Array<OctoWSFrame.Temp>) {
		temperatures = temp
		refresh()
		
	}
	
}
