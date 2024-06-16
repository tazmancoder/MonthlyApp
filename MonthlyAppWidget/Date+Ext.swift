//
//  Date+Ext.swift
//  MonthlyApp
//
//  Created by Mark Perryman on 6/16/24.
//

import Foundation

extension Date {
	var weekdayDisplayFormat: String {
		self.formatted(.dateTime.weekday(.wide))
	}
	
	var dayDisplayFormat: String {
		self.formatted(.dateTime.day())
	}
}
