//
//  SectionRowController.swift
//  WatchKitTableSample
//
//  Created by onegray on 5/2/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

import WatchKit

class SectionRowController: NSObject {
	
	@IBOutlet weak var titleLabel: WKInterfaceLabel!
	@IBOutlet weak var arrowLabel: WKInterfaceLabel!

	var rows = [AnyObject]()
}
