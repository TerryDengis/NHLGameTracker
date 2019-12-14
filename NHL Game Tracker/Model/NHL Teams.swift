//
//  NHL Teams.swift
//  NHL Game Tracker
//
//  Created by Terry Dengis on 1/7/19.
//  Copyright © 2019 Terry Dengis. All rights reserved.
//

import Foundation

struct NHLTeams: Codable {
    let copyright: String
    let teams: [LeagueTeam]
}

struct LeagueTeam: Codable {
    let id: Int
    let name, link: String
    let venue: Venue
    let abbreviation, teamName, locationName: String
    let firstYearOfPlay: String?
    let division: Division
    let conference: Conference
    let franchise: Franchise
    let shortName: String
    let officialSiteURL: String
    let franchiseID: Int
    let active: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, link, venue, abbreviation, teamName, locationName, firstYearOfPlay, division, conference, franchise, shortName
        case officialSiteURL = "officialSiteUrl"
        case franchiseID = "franchiseId"
        case active
    }
}

struct Conference: Codable {
    let id: Int
    let name: ConferenceName
    let link: ConferenceLink
}

enum ConferenceLink: String, Codable {
    case apiV1Conferences5 = "/api/v1/conferences/5"
    case apiV1Conferences6 = "/api/v1/conferences/6"
}

enum ConferenceName: String, Codable {
    case eastern = "Eastern"
    case western = "Western"
}

struct Division: Codable {
    let id: Int
    let name: DivisionName
    let nameShort: NameShort
    let link: DivisionLink
    let abbreviation: Abbreviation
}

enum Abbreviation: String, Codable {
    case a = "A"
    case c = "C"
    case m = "M"
    case p = "P"
}

enum DivisionLink: String, Codable {
    case apiV1Divisions15 = "/api/v1/divisions/15"
    case apiV1Divisions16 = "/api/v1/divisions/16"
    case apiV1Divisions17 = "/api/v1/divisions/17"
    case apiV1Divisions18 = "/api/v1/divisions/18"
}

enum DivisionName: String, Codable {
    case atlantic = "Atlantic"
    case central = "Central"
    case metropolitan = "Metropolitan"
    case pacific = "Pacific"
}

enum NameShort: String, Codable {
    case atl = "ATL"
    case cen = "CEN"
    case metro = "Metro"
    case pac = "PAC"
}

struct Franchise: Codable {
    let franchiseID: Int
    let teamName, link: String
    
    enum CodingKeys: String, CodingKey {
        case franchiseID = "franchiseId"
        case teamName, link
    }
}

struct Venue: Codable {
    let name, link, city: String
    let timeZone: TimeZone
    let id: Int?
}

struct TimeZone: Codable {
    let id: String
    let offset: Int
    let tz: Tz
}

enum Tz: String, Codable {
    case cst = "CST"
    case est = "EST"
    case mst = "MST"
    case pst = "PST"
}
