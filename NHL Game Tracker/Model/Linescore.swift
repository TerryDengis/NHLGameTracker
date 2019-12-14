//
//  Linescore.swift
//  NHL Game Tracker
//
//  Created by Terry Dengis on 1/1/19.
//  Copyright © 2019 Terry Dengis. All rights reserved.
//

import Foundation

struct Linescore: Codable {
    let currentPeriod: Int
    let currentPeriodOrdinal, currentPeriodTimeRemaining: String?
    let periods: [Period]
    let shootoutInfo: Shootout
    let teams: Teams
    let powerPlayStrength: String
    let hasShootout: Bool
    let powerPlayInfo: PowerPlayInfo?
    
    struct Period: Codable {
        let periodType: String
        let startTime: String?
        let endTime: String?
        let num: Int
        let ordinalNum: String
        let home, away: LSTeam
    }
    
    struct LSTeam: Codable {
        let goals, shotsOnGoal: Int
        let rinkSide: String?
    }
    
    struct PowerPlayInfo: Codable {
        let situationTimeRemaining, situationTimeElapsed: Int
        let inSituation: Bool
    }
    
    struct Shootout: Codable {
        let away, home: ShootoutInfo
    }
    
    struct ShootoutInfo: Codable {
        let scores, attempts: Int
    }
    
    struct Teams: Codable {
        let home, away: Team
    }
    
    struct Team: Codable {
        let team: TeamID
        let goals, shotsOnGoal: Int
        let goaliePulled: Bool
        let numSkaters: Int
        let powerPlay: Bool
    }
    
    struct TeamID: Codable {
        let id: Int
        let name, link: String
    }
}
