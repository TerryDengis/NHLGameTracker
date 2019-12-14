//
//  Game.swift
//  NHL Game Tracker
//
//  Created by Terry Dengis on 12/29/18.
//  Copyright © 2018 Terry Dengis. All rights reserved.
//

import Foundation

struct Game: Codable {
    let gamePk: Int
    let link: String
    let gameData: GameData
    let liveData: LiveData
}

struct GameData: Codable {
    let game: TheGame
    let datetime: Datetime
    let status: Status
    let teams: Teams
}

struct Datetime: Codable {
    let dateTime: String
    let endDateTime: String?
}

struct TheGame: Codable {
    let pk: Int
    let season: String
    let type: GameType
}

enum GameType: String, Codable {
    case regularSeason = "R"
    case preseason = "PR"
    case playoff = "P"
}
struct Status: Codable {
    //let abstractGameState: String
    //let codedGameState: String
    let detailedState: String
    let statusCode: statusCodeType
}

struct Teams: Codable {
    let away, home: Team
}

struct Team: Codable {
    let id: Int
    let link: String
    let triCode: TriCodeEnum?
    let teamName: String
    let name: String
}

struct LiveData: Codable {
    let plays: Plays
    let linescore: Linescore?
}

struct Plays: Codable {
    let allPlays: [Play]
    //let scoringPlays, penaltyPlays: [Int]
    let playsByPeriod: [PlaysByPeriod]
    let currentPlay: CurrentPlay?
}

struct CurrentPlay: Codable {
    let about: About
}

struct About: Codable {

    let period: Int
    let periodType: String
    let ordinalNum: String
    let periodTimeRemaining: String
}

struct PlaysByPeriod: Codable {
    let startIndex: Int
    //let plays: [Int]
    let endIndex: Int
}

struct Play: Codable {
    let result: PlayResult
    let coordinates: Coordinates
    let team: CurrentTeamClass?
}

struct CurrentTeamClass: Codable {
    let id: Int
    let link: String
    let triCode: TriCodeEnum?
}

enum TriCodeEnum: String, Codable {
    case Anaheim = "ANA" //    Anaheim (Mighty) Ducks
    case Arizona = "ARI" //     Arizona Coyotes
    case Boston = "BOS"//    Boston Bruins
    case Buffalo = "BUF" //     Buffalo Sabres
    case Calgary = "CGY" //     Calgary Flames
    case Carolina = "CAR" //     Carolina Hurricanes
    case Chicago = "CHI" //     Chicago Blackhawks
    case Colorado = "COL" //    Colorado Avalanche
    case Columbus = "CBJ" //     Columbus Blue Jackets
    case Dallas = "DAL" //     Dallas Stars
    case Detroit = "DET" //    Detroit Red Wings
    case Edmonton = "EDM" //     Edmonton Oilers
    case Florida = "FLA" //    Florida Panthers
    case LosAngeles = "LAK" //    Los Angeles Kings
    case Minnesota = "MIN" //    Minnesota Wild
    case Montreal = "MTL" //    Montreal Canadiens
    case Nashville = "NSH" //    Nashville Predators
    case Islanders = "NYI" //    New York Islanders
    case NewJersey = "NJD" //    New Jersey Devils
    case Rangers = "NYR" //    New York Rangers
    case Ottawa = "OTT" //    Ottawa Senators
    case Philadelphia = "PHI" //    Philadelphia Flyers
    case Pittsburgh = "PIT" //    Pittsburgh Penguins
    case SanJose = "SJS" //    San Jose Sharks
    case StLouis = "STL" //    St. Louis Blues
    case TampaBay = "TBL" //    Tampa Bay Lightning
    case Toronto = "TOR" //    Toronto Maple Leafs
    case Vancouver = "VAN" //    Vancouver Canucks
    case Vegas = "VGK" // Vegas Golden Knights
    case Washington = "WSH" //    Washington Capitals
    case Winnipeg = "WPG" //    Winnipeg Jets
    
    // Old Teams
    case AtlantaFlames = "AFM" //    Atlanta Flames
    case Atlanta = "ATL" //     Atlanta Thrashers
    case California = "CSE" //    California Seals
    case Cleveland = "CBN" //    Cleveland Barons
    case ColRock = "CLR" //   Colorado Rockies
    case Hartford = "HFD" //    Hartford Whalers
    case KansasCity = "KCS" //    Kansas City Scouts
    case MinnesotaNS = "MNS" //    Minnesota North Stars
    case Oakland = "OAK" //    Oakland Seals
    case Phoenix = "PHX" //    Phoenix Coyotes
    case Quebec = "QUE" //    Quebec Nordiques
    case Winnipeg92 = "WIN" //    Winnipeg Jets (1979-92)
}

struct Coordinates: Codable {
    let x, y: Int?
}

struct PlayResult: Codable {
    let eventCode: String
    let eventTypeID: EventTypeID
    let description: String
    enum CodingKeys: String, CodingKey {
        case eventCode
        case eventTypeID = "eventTypeId"
        case description
    }
}

enum EventTypeID: String, Codable {
    case blockedShot = "BLOCKED_SHOT"
    case faceoff = "FACEOFF"
    case gameEnd = "GAME_END"
    case gameScheduled = "GAME_SCHEDULED"
    case giveaway = "GIVEAWAY"
    case goal = "GOAL"
    case hit = "HIT"
    case missedShot = "MISSED_SHOT"
    case penalty = "PENALTY"
    case periodEnd = "PERIOD_END"
    case periodOfficial = "PERIOD_OFFICIAL"
    case periodReady = "PERIOD_READY"
    case periodStart = "PERIOD_START"
    case shot = "SHOT"
    case stop = "STOP"
    case takeaway = "TAKEAWAY"
    case challenge = "CHALLENGE"
    case shootoutComplete = "SHOOTOUT_COMPLETE"
    case gameOfficial = "GAME_OFFICIAL"
}
