//
//  CompositeTableInterfaceController.swift
//  WatchKitTableSample
//
//  Created by onegray on 4/28/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

import WatchKit
import Foundation


class CompositeTableInterfaceController: WKInterfaceController {

	@IBOutlet weak var table: WKInterfaceTable!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.

		let data: [[String:AnyObject]] = [
			[
				"title":"Breakfast",
				"items":["Coffee", "Oatmeal Oats"]
			],
			[
				"title":"Lunch",
				"items":["Vegetable Soup", "Chicken salad", "Pizza"]
			],
			[
				"title":"Dinner",
				"items":["Brown Rice", "Grilled Salmon"]
			]
		]
		
		buildTable(data)
		
    }

	func buildTable(data: [[String:AnyObject]]) {
		
		let builder = WKInterfaceTable.Builder()
		
		for section in data {
			let sectionTitle = section["title"] as! String
			builder.addCell("HeaderCell") { (cell: LabelCellController) -> Void in
				cell.label.setText(sectionTitle)
			}
			
			let items = section["items"] as! [String]
			for item in items {
				builder.addCell("ItemCell") { (cell: LabelCellController) -> Void in
					cell.label.setText(item)
				}
			}
		}
		
		builder.instantiateTableCells(table)
	}
	

	override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
