//
//  WKTableBuilder.swift
//  WKTableBuilder
//
//  Created by onegray on 4/24/15.
//  Copyright (c) 2015 onegray. All rights reserved.
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

