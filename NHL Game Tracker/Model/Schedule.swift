//
//  Schedule.swift
//  NHL Game Tracker
//
//  Created by Terry Dengis on 1/1/19.
//  Copyright © 2019 Terry Dengis. All rights reserved.
//

import Foundation

struct Schedule: Codable {
    //let copyright: String
    //let totalItems: Int
    //let totalEvents: Int
    let totalGames: Int
    //let totalMatches: Int
    //let wait: Int
    let dates: [Dates]
}

struct Dates: Codable {
    let date: String
    //let totalItems, totalEvents, totalGames, totalMatches: Int
    let games: [GameInfo]
   // let events, matches: [JSONAny]

}

//the Games that are in the schedule
struct GameInfo: Codable {

    let gamePk: Int
    let link: String
    let gameType: GameType
    let season: String
    let gameDate: String
    let status: Status
    let teams: Teams

    enum GameType: String, Codable {
        case playoff = "P"
        case preseason = "PR"
        case regularSeason = "R"
    }
    struct Teams: Codable {
        let away: Team
        let home: Team
    }
    struct Team: Codable {
        let score: Int
        let team: TeamID
    }
    struct Status: Codable {

        //let abstractGameState: String
        //let codedGameState: String
        let detailedState: String
        let statusCode: statusCodeType
        //let startTimeTBD: Bool
    }
    
    struct TeamID: Codable {
        let id: Int
        let name: String
        let link: String
    }
}

enum statusCodeType: String, Codable {
    case scheduled = "1"
    case pregame = "2"
    case inProgress = "3"
    case inProgressCritical = "4"
    case gameOver = "5"
    case unofficial = "6"
    case final = "7"
}
