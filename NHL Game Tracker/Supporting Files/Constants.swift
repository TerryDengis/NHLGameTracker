//
//  Constants.swift
//  NHL Game Tracker
//
//  Created by Terry Dengis on 1/1/19.
//  Copyright © 2019 Terry Dengis. All rights reserved.
//

import Foundation
import UIKit

let domainURLString = "https://statsapi.web.nhl.com"
let scheduleURLString = "https://statsapi.web.nhl.com/api/v1/schedule"
let gameDetailSegue = "gameViewSegue"

let shotsAvailable = "2010-10-07"

// team home primary colors
let atlanta = "#041E42"
let anaheim = "#FA7A38"
let arizona = "#8C2633"
let boston = "#FFB81C"
let buffalo = "#002654"
let calgary = "#C8102E"
let carolina = "#CC0000"
let chicago = "#CF0A2C"
let colorado = "#6F263D"
let columbus = "#002654"
let dallas = "#006847"
let detroit = "#CE1126"
let edmonton = "#FF4C00"
let florida = "#041E42"
let hartford = "#046A38"
let losAngeles = "#111111"
let minnesota = "#154734"
let minnestotaNS = "#007A33"
let montreal = "#AF1E2D"
let nashville = "#FFB81C"
let newJersey = "#CE1126"
let newYork = "#0038A8"
let newYorkIslanders = "#00539B"
let ottawa = "#E31837"
let philadelphia = "#F74902"
let pittsburgh = "#000000"
let quebec = "#005EB8"
let sanJose = "#006D75"
let stLouis = "#002F87"
let tampaBay = "#002868"
let toronto = "#003E7E"
let vancouver = "#001F5B"
let vegas = "#B4975A"
let washington = "#041E42"
let winnipeg = "#041E42"


/// Date Format type
enum DateFormatType: String {
    /// Time
    case time = "HH:mm:ss"
    
    case timeAM = "h:mm a"
    
    /// Date with hours
    case dateWithTime = "dd-MMM-yyyy  h:mm a"
    
    /// Date
    case date = "dd-MMM-yyyy"
    
    // reverseDate
    case reverseDate = "yyyy-MM-dd"
}
