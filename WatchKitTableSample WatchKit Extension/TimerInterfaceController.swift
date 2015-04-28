//
//  TimerInterfaceController.swift
//  WatchKitTableSample
//
//  Created by onegray on 4/27/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

import WatchKit
import Foundation


class TimerInterfaceController: WKInterfaceController {

	@IBOutlet weak var table: WKInterfaceTable!

	weak var timerCell: TimerCellController?
	
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
		// Configure interface objects here.
		
		var builder = WKInterfaceTable.Builder()
		
		builder.addCell("TimerCell") { (cell:TimerCellController) -> Void in
			cell.timer.setTextColor(UIColor.cyanColor())
			self.timerCell = cell
		}

		builder.addCell("StartCell") { (cell:LabelCellController) -> Void in
			WKInterfaceTable.setDidSelectHandler(cell) {
				self.timerCell?.timer.start()
			}
		}

		builder.addCell("StopCell") { (cell:LabelCellController) -> Void in
			WKInterfaceTable.setDidSelectHandler(cell) {
				self.timerCell?.timer.stop()
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
