# WKInterfaceTable extensions (Swift)
A couple of helpers to manage WatchKit table cells without indices.  

#### Overview
`WKInterfaceTable` is so simple, as the following trivial usage instructions:  
- Create table rows by `setRowTypes:`/`setNumberOfRows:withRowType:`  
- Use `rowControllerAtIndex:` to retrieve each row and configure its content.  

The official way requires to access a table row by index. It’s not so bad when the table structure is static, and row indices are constants. But even in this way the code does not look enough elegant due to manipulation with indices, and it can cause a real headache if the table structure is complex.

#### Build table without indices
Use the `builder` object to describe table structure:  

	var builder = WKInterfaceTable.Builder()

Add some cell definitions:  

	builder.addCell("RowTypeId") { (cell: CellController) -> Void in
		// Configuration closure to setup and fill cell data
		// Called just after cell is created
		cell.label.setText("Hello table")
		
		// Or store cell reference for future access
		self.certainCell = cell
	}


Finally, apply the results to a `WKInterfaceTable` object:  

	builder.instantiateTableCells(table)


#### Handle row selection

Bind selection handler to the target `cell`:  

	WKInterfaceTable.setDidSelectHandler(cell) { 
		NSLog("Cell Clicked")
	}


Override interface controller’s `table:didSelectRowAtIndex:` method:  

	override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
		table.handleDidSelectRowAtIndex(rowIndex)
	}


#### Sample App

[WatchKitTableSample.zip](https://github.com/onegray/WKInterfaceTableExtensions/archive/WatchKitTableSample.zip)