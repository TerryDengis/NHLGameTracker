//
//  ScheduleViewController.swift
//  NHL Game Tracker
//
//  Created by Terry Dengis on 12/29/18.
//  Copyright © 2018 Terry Dengis. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var scheduleResults: Schedule?
    var linescores: [Int:Linescore] = [:]
    var theGames = [GameInfo]()
    
    var gameDate = Date ()
    var gameDateString = ""
    var gameLink = ""

    var datePickerDisplayed = false
    var dateDisplayCellIndexPath = IndexPath (row: 0, section: 0)
    var datePickerIndexPath = IndexPath (row: 1, section: 0)
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameDateString = gameDate.convertToString(dateformat: .reverseDate)
        
        tableView.register(UINib (nibName: GameCell.nibName(), bundle : nil), forCellReuseIdentifier: GameCell.reuseIdentifier())
        tableView.register(UINib(nibName: DateDisplayCell.nibName(), bundle: nil), forCellReuseIdentifier: DateDisplayCell.reuseIdentifier())
        tableView.register(UINib(nibName: DatePickerCell.nibName(), bundle: nil), forCellReuseIdentifier: DatePickerCell.reuseIdentifier())
        
        refreshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
        
        tableView.refreshControl = refreshControl

    }
    
    override func viewWillAppear(_ animated: Bool) {

        fetchSchedule(for: gameDateString, completed:{ self.getLinescores()})
    }
        
    @objc func reloadData () {
        refreshControl.beginRefreshing()

        fetchSchedule(for: gameDateString, completed:{ self.getLinescores()})
    }

    //MARK: view update methods
    func updateViewFromModel () {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        refreshControl.endRefreshing()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true

    }
    
    func getStartTime (game: GameInfo) -> String {
        let gameDateString = game.gameDate
        let formatter = DateFormatter ()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let gameDateString = formatter.date(from: gameDateString) {
            return gameDateString.convertToString(dateformat: .timeAM)
        }
        return "error"
    }
    
    func getTimeRemaining (game: Int) -> String {
        let linescore = linescores [game]
        
        return "\(linescore?.currentPeriodTimeRemaining ?? "error")  \(linescore?.currentPeriodOrdinal ?? "error")"
    }
    
    func getFinalStatus (game:Int) -> String {
        //do we want to say shoot out or overtime if applicable?
        let linescore = linescores [game]
        if linescore?.currentPeriod == 3 {
            return "Final"
        }
        else {
            return "Final (\(linescore?.currentPeriodOrdinal ?? "error"))"
        }
    }
    
    //MARK: JSON Query methods
    @objc func getLinescores () {
        
        if scheduleResults?.totalGames == 0 {
            theGames.removeAll()
            tableView.reloadData()
            linescores.removeAll()
            updateViewFromModel()
        }
        else {
            // since we are only doing a query for 1 day
            theGames = (scheduleResults?.dates[0].games)!
            for game in theGames {
                fetchLinescore(for: game.gamePk, completed:{ self.linescoreCounter ()})
            }
        }
    }
    
    @objc func linescoreCounter () {
        //wait until all of the linescores are back before updating the view
        if theGames.count == linescores.count {
            updateViewFromModel()
        }
    }
    
    func fetchSchedule (for date: String, completed:@escaping ()->() ) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false

        linescores.removeAll()
        let urlString = "\(scheduleURLString)?date=\(date)"
        print ("fetchSchedule :", urlString)
        guard let url = URL(string: urlString) else { return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                do {
                    self.scheduleResults = try JSONDecoder().decode(Schedule.self, from: data!)
                    DispatchQueue.main.async {
                        completed ()
                    }
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
        }.resume()
    }
    
    func fetchLinescore (for gameID: Int, completed:@escaping ()->() ) {
        let urlString = "\(domainURLString)/api/v1/game/\(gameID)/linescore"
        print("fetchLinescore: ", urlString)
        guard let url = URL(string: urlString) else { return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                do {
                    let newLinescore = try JSONDecoder().decode(Linescore.self, from: data!)
                    
                    self.linescores [gameID] = newLinescore
                    
                    DispatchQueue.main.async {
                        completed ()
                    }
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
            }.resume()
    }

    //MARK: Navigation methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == gameDetailSegue {
            if let gvc = segue.destination as? GameViewController {
                gvc.gameDetailLink = gameLink
            }
        }
    }
}

//MARK: TableView datsource methods
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            // this is the datePicker
            if datePickerIndexPath == indexPath {
                let datePickerCell = tableView.dequeueReusableCell(withIdentifier: DatePickerCell.reuseIdentifier()) as! DatePickerCell
                
                datePickerCell.setValue(UIColor.white, forKeyPath: "textColor")
                datePickerCell.upDateDisplayCell(date: gameDate)
                datePickerCell.delegate = self //as DatePickerDelegate
                
                return datePickerCell
            } else {
                let dateDisplayCell = tableView.dequeueReusableCell(withIdentifier: DateDisplayCell.reuseIdentifier()) as! DateDisplayCell
                dateDisplayCell.updateText(date: gameDate)
                dateDisplayCell.delegate = self //as DatePickerDelegate
                return dateDisplayCell
            }
        } else {
            let lineItem = tableView.dequeueReusableCell(withIdentifier: GameCell.reuseIdentifier(), for: indexPath) as! GameCell
            let game = theGames[indexPath.row]
            let teams = game.teams
            let statusCode = game.status.statusCode
            
            lineItem.visitingTeam.image = UIImage(named: teams.away.team.name)
            lineItem.homeTeam.image = UIImage(named: teams.home.team.name)
            lineItem.homeScore.text = String(teams.home.score)
            lineItem.vistingScore.text = String(teams.away.score )
            lineItem.homeName.text = teams.home.team.name
            lineItem.visitingName.text = teams.away.team.name
                
            switch statusCode {
            case .scheduled, .pregame :
                lineItem.gameStatus.text = getStartTime(game: game)
            case .inProgress, .inProgressCritical:
                lineItem.gameStatus.text = getTimeRemaining(game: game.gamePk)
            case .final, .gameOver, .unofficial:
                lineItem.gameStatus.text = getFinalStatus(game: game.gamePk)
            }
            return lineItem
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if datePickerDisplayed {
                return 2
            }
            else {
                return 1
            }
        case 1:
            return theGames.count
        default :
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == datePickerIndexPath {
            return DatePickerCell.cellHeight()
        } else if indexPath == dateDisplayCellIndexPath {
            return DateDisplayCell.cellHeight()
        } else {
            return GameCell.cellHeight()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

//MARK: TableView delegate methods
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            gameLink = theGames[indexPath.row].link
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: gameDetailSegue, sender: self)
            
        } else {
            if indexPath == dateDisplayCellIndexPath {
                tableView.beginUpdates()
                
                if datePickerDisplayed {
                    tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
                    tableView.deselectRow(at: dateDisplayCellIndexPath, animated: true)
                    
                }
                else {
                    tableView.insertRows(at: [datePickerIndexPath], with: .fade)
                }
                datePickerDisplayed = !datePickerDisplayed
                tableView.endUpdates()
            }
        }
    }
}

//MARK: DatePicker delegate methods
extension ScheduleViewController: DateDisplayDelegate, DatePickerDelegate {
    
    func didChangeDate(date: Date) {
        gameDate = date
        gameDateString = date.convertToString(dateformat: DateFormatType.reverseDate)
//        let formatter = DateFormatter ()
//
//        formatter.dateFormat = "yyyy-MM-dd"
//
//        if gameDate.compare(formatter.date(from: shotsAvailable)!) == .orderedAscending {
//            tableView.allowsSelection = false
//        } else {
//            tableView.allowsSelection = true
//        }

        fetchSchedule(for: gameDateString, completed:{ self.getLinescores()})
    }
    
}

