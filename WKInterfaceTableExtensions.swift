//
//  WKInterfaceTableExtensions.swift
//
//  Created by Sergey Nikitenko on 4/24/15.
//  Copyright (c) 2015 Sergey Nikitenko. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import WatchKit

extension WKInterfaceTable {
	
	class Builder {
		
		func addRow<T> (rowType: String, configure: (row:T) -> Void )  {
			let configurator = GenericRowConfigureBlock(configure)
			let rowConfiguration = RowConfiguration(rowType, configurator: configurator)
			tableConfiguration.append(rowConfiguration)
		}
		
		func instantiateTableRows(table: WKInterfaceTable) {
			let rowTypes = tableConfiguration.map({$0.rowType})
			table.setRowTypes(rowTypes)
			for (rowIndex, rowConfiguration) in enumerate(tableConfiguration) {
				let row: AnyObject = table.rowControllerAtIndex(rowIndex)!
				rowConfiguration.configurator.configure(row)
			}
		}

		
		private class RowConfigureBlock {
			func configure(row: AnyObject) {}
		}
		
		private class RowConfiguration {
			let rowType: String
			let configurator: RowConfigureBlock
			init (_ rowType: String, configurator: RowConfigureBlock ) {
				self.rowType = rowType
				self.configurator = configurator
			}
		}
		
		private var tableConfiguration = [RowConfiguration]()
	}
	
}

private class GenericRowConfigureBlock<T> : WKInterfaceTable.Builder.RowConfigureBlock {
	let configureBlock: T -> Void
	init(_ block: T -> Void ) {
		configureBlock = block
	}
	override func configure(row: AnyObject) {
		configureBlock(row as! T)
	}
}


extension WKInterfaceTable {
	
	func insertRowAtIndex (index: Int, rowType: String) -> AnyObject {
		insertRowsAtIndexes(NSIndexSet(index: index), withRowType: rowType)
		return rowControllerAtIndex(index)!
	}

	func insertRowsAtIndex (startIndex:Int, count: Int, rowType: String) -> [AnyObject] {
		let indexes = NSIndexSet(indexesInRange: NSMakeRange(startIndex, count))
		insertRowsAtIndexes(indexes, withRowType: rowType)
		var rows: [AnyObject] = []
		for i in 0..<count {
			rows.append(rowControllerAtIndex(startIndex+i)!)
		}
		return rows
	}

	func insertRowsAfter (targetRow: AnyObject, count: Int, rowType: String) -> [AnyObject] {
		return insertRowsAtIndex(indexOfRow(targetRow)! + 1, count: count, rowType: rowType)
	}
	
	
	func removeRowAtIndex (index: Int) {
		removeRowsAtIndexes(NSIndexSet(index: index))
	}
	
	func removeRow (row: AnyObject) {
		if let rowIndex = indexOfRow(row) {
			removeRowsAtIndexes(NSIndexSet(index: rowIndex))
		}
	}

	func removeRows (rows: [AnyObject]) {
		if rows.count > 0 {
			let indices = NSMutableIndexSet()
			var rowIndex = 0
			for row in rows {
				if row === rowControllerAtIndex(rowIndex) {
					indices.addIndex(rowIndex++)
				} else if let index = indexOfRow(row) {
					indices.addIndex(index)
					rowIndex = index + 1
				}
			}
			removeRowsAtIndexes(indices)
		}
	}

	
	func indexOfRow (row: AnyObject) -> Int? {
		for i in 0..<numberOfRows {
			if row === rowControllerAtIndex(i) {
				return i
			}
		}
		return nil
	}
	

}


extension WKInterfaceTable {
	
	class func setDidSelectHandler(row:AnyObject, handler: Void->Void) {
		let rowAction = RowActionHandler(handler)
		objc_setAssociatedObject(row, &RowActionProperty.key, rowAction,
			objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
	}

	
	func handleDidSelectRowAtIndex(rowIndex: Int) {
		if let row: AnyObject = rowControllerAtIndex(rowIndex) {
			if let action = objc_getAssociatedObject(row, &RowActionProperty.key) as? RowActionHandler {
				action.fire()
			}
		}
	}

	private class RowActionHandler : NSObject {
		let handler: Void->Void
		init(_ handler: Void->Void ) {
			self.handler = handler
		}
		func fire() {
			handler()
		}
	}
	
	private struct RowActionProperty {
		static var key = "rowAction"
	}
}

