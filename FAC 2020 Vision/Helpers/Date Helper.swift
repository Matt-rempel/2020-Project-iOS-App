//
//  Date Helper.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-10.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import Foundation

class DateFormater {
    let formatter = DateFormatter()
    
    init() {
        formatter.locale = Locale(identifier: "en_US_POSIX")
    }
    
    /**
     Format: yyyy-MM-dd
     Example: 2020-01-01
     */
    func getDateFrom(string: String) -> Date? {
        formatter.dateFormat = "yyyy-MM-dd"
		return formatter.date(from:string)
	}
	
    /**
     Format: dd-MM-yyyy
     Example: 01-01-2020
     */
	func getStringFrom(date: Date) -> String {
		formatter.dateFormat = "dd-MM-yyyy"
		return formatter.string(from: date)
	}
	
    /**
     Format: dd-MM-yyyy
     Example: 01-01-2020
     */
    func getDateDDMMYYYYFrom(input: String) -> Date? {
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.date(from: input)
    }
    
    /**
     Format: d
     Example:  1
     */
	func getStringDateOfMonth(date: Date?) -> String {
		if let date = date {
			formatter.dateFormat = "d"
			return formatter.string(from: date)
		} else {
			return ""
		}
	}
	
    /**
     Format: h:mm a
     Example: 9:21 am
     */
	func getTimeFromString(string: String) -> Date? {
        formatter.dateFormat = "h:mm a"
		return formatter.date(from:string)
	}
	
    /**
     Format: h:mm a
     Example: 9:21 am
     */
	func getStringFrom(time: Date) -> String {
		formatter.dateFormat = "h:mm a"
		return formatter.string(from: time)
	}
	
    /**
     Format: MMMM d
     Example: January 1
     */
	func getPrettyStringFrom(date: Date?) -> String {
		if let date = date {
			formatter.dateFormat = "MMMM d"
			return formatter.string(from: date)
		} else {
			return ""
		}
	}
	
    /**
     Format: MMM d
     Example: Jan 1
     */
	func getPrettyShortMonthStringFrom(date: Date?) -> String {
		if let date = date {
			formatter.dateFormat = "MMM d"
			return formatter.string(from: date)
		} else {
			return ""
		}
	}
	
    /**
     Format: EEEE, MMMM d
     Example:  Monday, January 1
     */
	func getPrettyStringWithDayOfWeekFrom(date: Date?) -> String {
		if let date = date {
			formatter.dateFormat = "EEEE, MMMM d"
			return formatter.string(from: date)
		} else {
			return ""
		}
	}

    /**
     Format: MMMM
     Example: January
     */
	func getCurrentMonthString() -> String {
		let now = Date()
        return self.getMonthString(input: now)
	}
	
    /**
     Format: yyyy
     Example: 2020
     */
	func getCurrentYearString() -> String {
		let now = Date()
        formatter.dateFormat = "yyyy"
		return formatter.string(from: now)
	}
	
    /**
     Format: MMMM
     Example: January
     */
	func getMonthString(input: Date) -> String {
        formatter.dateFormat = "MMMM"
		return formatter.string(from: input)
	}
    
    /**
     Format: MM d, yyyy
     Example: Dec 8, 2020
     */
    func getMedDate(input: Date) -> String {
        formatter.dateStyle = .medium
        return formatter.string(from: input)
    }
    
    /**
     Converts month name to int
     Example: January to 1
     */
    func monthNameToInt(input: String) -> Int {
        var month = 1
        formatter.dateFormat = "MMMM"
        if let date = formatter.date(from: input) {
            month = Calendar.current.component(.month, from: date)
        }
        return month
    }
	
    func devoIDToParts(devoID: String) -> (Int?, Int?, Int?) {
        var year:Int?
        var month:Int?
        var day: Int?
        
        if let date = self.getDateDDMMYYYYFrom(input: devoID) {
            year = Calendar.current.component(.year, from: date)
            month = Calendar.current.component(.month, from: date)
            day = Calendar.current.component(.day, from: date)
        }
        
        return (year, month, day)
    }
    
    /**
     Gets the months so far since Jan 1, 2020
     */
	func getMonthsSoFar() -> [String] {
		
		var output:[String] = []
		
		let currentMonthString = getMonthString(input: Date())
		var counterMonth = self.getDateFrom(string: "01-01-2020")!
		var counterMonthString = getMonthString(input: counterMonth)
		
		while currentMonthString != counterMonthString {
			output.append(counterMonthString)
			counterMonth = Calendar.current.date(byAdding: .month, value: 1, to: counterMonth)!
			counterMonthString = getMonthString(input: counterMonth)
		}
		
		output.append(currentMonthString)
		
		return output
	}
	
    /**
     Will return "Today" or "Yesterday" or a date String depending on what the given date is
     */
	func getRelativeDateString(date: Date?) -> String {
		let current = Calendar.current
		if let date = date {
			if current.isDateInToday(date) {
				return "Today"
			} else if current.isDateInYesterday(date){
				return "Yesterday"
			} else {
				return self.getPrettyStringFrom(date: date)
			}
		} else {
			return ""
		}
	}
    
    /**
     Will sort and return an array of months in format MMMM (January)
     */
    func getSortedMonthsArray(months: [String]) -> [String] {
        formatter.dateFormat = "MMMM"
        let sortedArrayOfMonths = months.sorted( by: { formatter.date(from: $0)! < formatter.date(from: $1)! })
        return sortedArrayOfMonths
    }
}
