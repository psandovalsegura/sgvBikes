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
    
    static func getTimeDifference(_ date1: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate = Date()
        var currentDateString = String(describing: currentDate)
        for _ in 1...6 {
            currentDateString.remove(at: currentDateString.characters.index(before: currentDateString.endIndex))
        }
        
        let date1Readable = dateFormatter.date(from: date1)!
        let date2Readable = dateFormatter.date(from: currentDateString)!
        let diffDateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: date1Readable, to: date2Readable, options: NSCalendar.Options.init(rawValue: 0))
        
        // "The difference between dates is: \(diffDateComponents.year) years, \(diffDateComponents.month) months, \(diffDateComponents.day) days, \(diffDateComponents.hour) hours, \(diffDateComponents.minute) minutes, \(diffDateComponents.second) seconds"
        //Need to correct values when not in testing -- NOT ACCURATE
        var dayCount = 0; dayCount += (diffDateComponents.year! * 365); dayCount += (diffDateComponents.month! * 30); dayCount += (diffDateComponents.day)!;
        
        return "\(dayCount) days"
        
    }
    
    static func getTimeDifferencePhrase(_ date1: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate = Date()
        var currentDateString = String(describing: currentDate)
        for _ in 1...6 {
            currentDateString.remove(at: currentDateString.characters.index(before: currentDateString.endIndex))
        }
        
        let date1Readable = dateFormatter.date(from: date1)!
        let date2Readable = dateFormatter.date(from: currentDateString)!
        let diffDateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: date1Readable, to: date2Readable, options: NSCalendar.Options.init(rawValue: 0))
        
        // "The difference between dates is: \(diffDateComponents.year) years, \(diffDateComponents.month) months, \(diffDateComponents.day) days, \(diffDateComponents.hour) hours, \(diffDateComponents.minute) minutes, \(diffDateComponents.second) seconds"
        //Need to correct values when not in testing -- NOT ACCURATE
        var dayCount = 0; dayCount += (diffDateComponents.year! * 365); dayCount += (diffDateComponents.month! * 30); dayCount += (diffDateComponents.day)!;
        
        let hourCount = diffDateComponents.hour
        let minuteCount = diffDateComponents.minute
        let secondCount = diffDateComponents.second
        
        if dayCount <= 0 {
            //Not a day has elapsed yet
            if hourCount! <= 0 {
                //Not an hour has elapsed yet
                if minuteCount! <= 0 {
                    //Not a minute has elapsed yet
                    if secondCount! <= 0 {
                        return "now"
                    } else if secondCount == 1 {
                        return "1 second ago"
                    } else {
                        return "\(secondCount!) seconds ago"
                    }
                    
                } else if minuteCount == 1 {
                    return "1 minute ago"
                } else {
                    return "\(minuteCount!) minutes ago"
                }
                
            } else if hourCount == 1 {
                return "1 hour ago"
            } else {
                return "\(hourCount!) hours ago"
            }
            
        } else if dayCount == 1 {
            return "\(dayCount) day ago"
        }
        
        return "\(dayCount) days"
        
    }
    
    /* A truncated version of getTimeDifference() for the Home View Feed
     *
     */
    
    static func getFeedTimeDifference(_ date1: String) -> String {
        var timeDifferenceString = getTimeDifference(date1)
        for _ in 1...3 {
            timeDifferenceString.remove(at: timeDifferenceString.characters.index(before: timeDifferenceString.endIndex))
        }
        
        return timeDifferenceString
    }
    
    /* Returns a string of the date in the format: Ex. "2016-06-22 04:08:11"  */
    static func getFormattedDate() -> String {
        let currentDate = Date()
        var currentDateString = String(describing: currentDate)
        for _ in 1...6 {
            currentDateString.remove(at: currentDateString.characters.index(before: currentDateString.endIndex))
        }
        return currentDateString
    }
    
    
    /* Returns a string of the date in the format: Ex. "Jun 21, 2016, 9:40 PM" 
       Receiving a string in the format: "yyyy-MM-dd HH:mm:ss" 
     */
    static func getReadableDateFromFormat(_ formattedDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let tryingDate = dateFormatter.date(from: formattedDate)!
        
        let timestamp = DateFormatter.localizedString(from: tryingDate, dateStyle: .medium, timeStyle: .short)
        return timestamp
    }
    
    /* Credit for getTimestamp() function to Scott Gardner on Stack Overflow: http://stackoverflow.com/questions/24070450/how-to-get-the-current-time-and-hour-as-datetime
        
     Output string format example: Jun 21, 2016, 9:40 PM
     */
    static func getTimestamp() -> String{
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        
        return timestamp
    }
}

extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
