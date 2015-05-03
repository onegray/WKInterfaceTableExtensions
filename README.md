# WKInterfaceTable extensions (Swift)
A couple of helpers to manage WatchKit table rows without indices.  

#### Overview
`WKInterfaceTable` is so simple, as the following trivial usage instructions:  
- Create table rows by `setRowTypes:`/`setNumberOfRows:withRowType:`  
- Use `rowControllerAtIndex:` to retrieve each row and configure its content.  

The official way requires to access a table row by index. It’s not so bad when the table structure is static, and row indices are constants. But even in this way the code does not look enough elegant due to manipulation with indices, and it can cause a real headache if the table structure is complex.

#### Build table without indices
Use the `builder` object to describe table structure:  

	var builder = WKInterfaceTable.Builder()

Add some row definitions:  

	builder.addRow("RowTypeId") { (row: RowController) -> Void in
		// Configuration closure to setup and fill row data
		// Called just after row is created
		row.label.setText("Hello table")
		
		// Or store row reference for future access
		self.certainRow = row
	}


Finally, apply the results to a `WKInterfaceTable` object:  

	builder.instantiateTableRows(table)


#### Handle row selection

Bind selection handler to the target `row`:  

	WKInterfaceTable.setDidSelectHandler(row) { 
		NSLog("Row Clicked")
	}


Override interface controller’s `table:didSelectRowAtIndex:` method:  

	override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
		table.handleDidSelectRowAtIndex(rowIndex)
	}


#### Sample App

[WatchKitTableSample.zip](https://github.com/onegray/WKInterfaceTableExtensions/archive/WatchKitTableSample.zip)