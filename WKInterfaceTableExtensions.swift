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
		
		func addCell<T> (rowType: String, configure: (cell:T) -> Void )  {
			let configurator = GenericCellConfigureBlock(configure)
			let cellConfiguration = CellConfiguration(rowType, configurator: configurator)
			tableConfiguration.append(cellConfiguration)
		}
		
		func instantiateTableCells(table: WKInterfaceTable) {
			let rowTypes = tableConfiguration.map({$0.rowType})
			table.setRowTypes(rowTypes)
			for (rowIndex, cellConfiguration) in enumerate(tableConfiguration) {
				let cell: AnyObject = table.rowControllerAtIndex(rowIndex)!
				cellConfiguration.configurator.configure(cell)
			}
		}

		
		private class CellConfigureBlock {
			func configure(cell: AnyObject) {}
		}
		
		private class CellConfiguration {
			let rowType: String
			let configurator: CellConfigureBlock
			init (_ rowType: String, configurator: CellConfigureBlock ) {
				self.rowType = rowType
				self.configurator = configurator
			}
		}
		
		private var tableConfiguration = [CellConfiguration]()
	}
	
}

private class GenericCellConfigureBlock<T> : WKInterfaceTable.Builder.CellConfigureBlock {
	let configureBlock: T -> Void
	init(_ block: T -> Void ) {
		configureBlock = block
	}
	override func configure(cell: AnyObject) {
		configureBlock(cell as! T)
	}
}


extension WKInterfaceTable {
	
	func insertRowAtIndex (index: Int, rowType: String) -> AnyObject!  {
		self.insertRowsAtIndexes(NSIndexSet(index: index), withRowType: rowType)
		return rowControllerAtIndex(index)
	}
	
	func insertRowAtIndex<T> (index: Int, rowType: String, configure: (cell:T) -> Void )  {
		self.insertRowsAtIndexes(NSIndexSet(index: index), withRowType: rowType)
		let cell: AnyObject = rowControllerAtIndex(index)!
		configure(cell: cell as! T)
	}
	
}


extension WKInterfaceTable {
	
	class func setDidSelectHandler(cell:AnyObject, handler: Void->Void) {
		let cellAction = CellActionHandler(handler)
		objc_setAssociatedObject(cell, &CellActionProperty.key, cellAction,
			objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
	}

	
	func handleDidSelectRowAtIndex(rowIndex: Int) {
		if let cell: AnyObject = rowControllerAtIndex(rowIndex) {
			if let action = objc_getAssociatedObject(cell, &CellActionProperty.key) as? CellActionHandler {
				action.fire()
			}
		}
	}

	private class CellActionHandler : NSObject {
		let handler: Void->Void
		init(_ handler: Void->Void ) {
			self.handler = handler
		}
		func fire() {
			handler()
		}
	}
	
	private struct CellActionProperty {
		static var key = "cellAction"
	}
}

