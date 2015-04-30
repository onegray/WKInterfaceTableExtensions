//
//  TimerTableInterfaceController.swift
//  WatchKitTableSample
//
//  Created by onegray on 4/27/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

import WatchKit
import Foundation


class TimerTableInterfaceController: WKInterfaceController {

	@IBOutlet weak var table: WKInterfaceTable!

	weak var timerRow: TimerRowController?
	
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
		// Configure interface objects here.
		
		var builder = WKInterfaceTable.Builder()
		
		builder.addRow("TimerRowType") { (row: TimerRowController) -> Void in
			row.timer.setTextColor(UIColor.cyanColor())
			self.timerRow = row
		}

		builder.addRow("StartRowType") { (row: LabelRowController) -> Void in
			WKInterfaceTable.setDidSelectHandler(row) {
				self.timerRow?.timer.start()
			}
		}

		builder.addRow("StopRowType") { (row: LabelRowController) -> Void in
			WKInterfaceTable.setDidSelectHandler(row) {
				self.timerRow?.timer.stop()
			}
		}

		builder.instantiateTableRows(table)
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
