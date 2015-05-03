//
//  FoldingTableInterfaceController.swift
//  WatchKitTableSample
//
//  Created by onegray on 5/1/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

import WatchKit
import Foundation


class FoldingTableInterfaceController: WKInterfaceController {

	@IBOutlet weak var table: WKInterfaceTable!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
		
		let sectionTitles = ["Section 1", "Section 2", "Section 3", "Section 4"]
		
		var builder = WKInterfaceTable.Builder()
		
		for title in sectionTitles {
			builder.addRow("SectionRowType") { (sectionRow : SectionRowController) -> Void in
				sectionRow.titleLabel.setText(title)
				WKInterfaceTable.setDidSelectHandler(sectionRow) { [unowned sectionRow] in
					if sectionRow.rows.count > 0 {
						self.hideSectionItems(sectionRow)
					} else {
						self.showSectionItems(sectionRow)
					}
				}
			}
		}
		
		builder.instantiateTableRows(table)
    }


	func showSectionItems(sectionRow: SectionRowController) {
		let rowItems = ["Row Item 1", "Row Item 2", "Row Item 3"]
		sectionRow.rows = table.insertRowsAfter(sectionRow, count: rowItems.count, rowType: "ItemRowType")
		for i in 0..<sectionRow.rows.count {
			let row = sectionRow.rows[i] as! LabelRowController
			row.label.setText(rowItems[i])
		}
		sectionRow.arrowLabel.setText("▲")
	}

	func hideSectionItems(sectionRow: SectionRowController) {
		table.removeRows(sectionRow.rows)
		sectionRow.rows.removeAll(keepCapacity: true)
		sectionRow.arrowLabel.setText("▼")
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
