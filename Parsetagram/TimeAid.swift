//
//  TimeAid.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/21/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import Foundation

class TimeAid {
    /* This function returns a string representing the difference between two dates of the following format
     FORMAT: "yyyy-MM-dd HH:mm:ss"
     EX: "2016-06-22 04:08:11"
     
     @param
     date1: is a string representing the date and time in the format detailed above
     */
    
    static func getTimeDifference(date1: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate = NSDate()
        var currentDateString = String(currentDate)
        for _ in 1...6 {
            currentDateString.removeAtIndex(currentDateString.endIndex.predecessor())
        }
        
        let date1Readable = dateFormatter.dateFromString(date1)!
        let date2Readable = dateFormatter.dateFromString(currentDateString)!
        let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: date1Readable, toDate: date2Readable, options: NSCalendarOptions.init(rawValue: 0))
        
        // "The difference between dates is: \(diffDateComponents.year) years, \(diffDateComponents.month) months, \(diffDateComponents.day) days, \(diffDateComponents.hour) hours, \(diffDateComponents.minute) minutes, \(diffDateComponents.second) seconds"
        //Need to correct values when not in testing -- NOT ACCURATE
        var dayCount = 0; dayCount += (diffDateComponents.year * 365); dayCount += (diffDateComponents.month * 30); dayCount += (diffDateComponents.day);
        
        return "\(dayCount) days"
        
    }
    
    /* A truncated version of getTimeDifference() for the Home View Feed
     *
     */
    
    static func getFeedTimeDifference(date1: String) -> String {
        var timeDifferenceString = getTimeDifference(date1)
        for _ in 1...3 {
            timeDifferenceString.removeAtIndex(timeDifferenceString.endIndex.predecessor())
        }
        
        return timeDifferenceString
    }
    
    /* Returns a string of the date in the format: Ex. "2016-06-22 04:08:11"  */
    static func getFormattedDate() -> String {
        let currentDate = NSDate()
        var currentDateString = String(currentDate)
        for _ in 1...6 {
            currentDateString.removeAtIndex(currentDateString.endIndex.predecessor())
        }
        return currentDateString
    }
    
    
    /* Returns a string of the date in the format: Ex. "Jun 21, 2016, 9:40 PM" 
       Receiving a string in the format: "yyyy-MM-dd HH:mm:ss" 
     */
    static func getReadableDateFromFormat(formattedDate: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let tryingDate = dateFormatter.dateFromString(formattedDate)!
        
        let timestamp = NSDateFormatter.localizedStringFromDate(tryingDate, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        return timestamp
    }
    
    /* Credit for getTimestamp() function to Scott Gardner on Stack Overflow: http://stackoverflow.com/questions/24070450/how-to-get-the-current-time-and-hour-as-datetime
        
     Output string format example: Jun 21, 2016, 9:40 PM
     */
    static func getTimestamp() -> String{
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
        return timestamp
    }
}
