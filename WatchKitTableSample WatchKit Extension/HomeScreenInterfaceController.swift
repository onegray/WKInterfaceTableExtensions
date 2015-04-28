//
//  InterfaceController.swift
//  WatchKitTableSample WatchKit Extension
//
//  Created by onegray on 4/27/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

import WatchKit
import Foundation


class HomeScreenInterfaceController: WKInterfaceController {

	@IBOutlet weak var table: WKInterfaceTable!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
		// Configure interface objects here.

		var builder = WKInterfaceTable.Builder()

		builder.addCell("LabelCell") { (cell: LabelCellController) -> Void in
			cell.label.setText("Сomposite Table")
			WKInterfaceTable.setDidSelectHandler(cell) {
				self.pushControllerWithName("CompositeTableInterface", context: nil)
			}
		}

		builder.addCell("LabelCell") { (cell: LabelCellController) -> Void in
			cell.label.setText("Timer Sample")
			WKInterfaceTable.setDidSelectHandler(cell) {
				self.pushControllerWithName("TimerSampleInterface", context: nil)
			}
		}

		builder.instantiateTableCells(table)
    }

	override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
		table.handleDidSelectRowAtIndex(rowIndex)
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
