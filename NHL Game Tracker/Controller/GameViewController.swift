//
//  GameViewController.swift
//  NHL Game Tracker
//
//  Created by Terry Dengis on 12/31/18.
//  Copyright © 2018 Terry Dengis. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var iceView: UIView!
    
    @IBOutlet weak var firstPeriod: UIButton!
    @IBOutlet weak var secondPeriod: UIButton!
    @IBOutlet weak var thirdPeriod: UIButton!
    @IBOutlet weak var overtime: UIButton!
    @IBOutlet weak var shootout: UIButton!
    @IBOutlet weak var buttons: UIStackView!
    
    @IBOutlet weak var rightTeam: UIImageView!
    @IBOutlet weak var leftTeam: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var shotsHomeTeam: UILabel!
    @IBOutlet weak var shotsHome1st: UILabel!
    @IBOutlet weak var shotsHome2nd: UILabel!
    @IBOutlet weak var shotsHome3rd: UILabel!
    @IBOutlet weak var shotsHomeOT: UILabel!
    @IBOutlet weak var shotsHomeTotal: UILabel!
    @IBOutlet weak var shotsVisitorTeam: UILabel!
    @IBOutlet weak var shotsVisitor1st: UILabel!
    @IBOutlet weak var shotsVisitor2nd: UILabel!
    @IBOutlet weak var shotsVisitor3rd: UILabel!
    @IBOutlet weak var shotsVisitorOT: UILabel!
    @IBOutlet weak var shotsVisitorTotal: UILabel!
    @IBOutlet weak var shotsOTLabel: UILabel!
    
    @IBOutlet weak var scoreHomeTeam: UILabel!
    @IBOutlet weak var scoreHome1st: UILabel!
    @IBOutlet weak var scoreHome2nd: UILabel!
    @IBOutlet weak var scoreHome3rd: UILabel!
    @IBOutlet weak var scoreHomeOT: UILabel!
    @IBOutlet weak var scoreHomeTotal: UILabel!
    @IBOutlet weak var scoreVisitorTeam: UILabel!
    @IBOutlet weak var scoreVisitor1st: UILabel!
    @IBOutlet weak var scoreVisitor2nd: UILabel!
    @IBOutlet weak var scoreVisitor3rd: UILabel!
    @IBOutlet weak var scoreVisitorOT: UILabel!
    @IBOutlet weak var scoreVisitorTotal: UILabel!
    @IBOutlet weak var scoreOTLabel: UILabel!
    
    var scheduleResults: Game?
    var gameDetailLink: String?
    var period = 1
    var homeTeam:TriCodeEnum?
    var awayTeam:TriCodeEnum?
    var timer = Timer ()
    
    //private var observer: NSKeyValueObservation?

    //MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()

        //NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)

        firstPeriod.isSelected = true
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        fetchGameDetail { self.updateViewFromModel()}
    }
    
//    @objc func deviceRotated () {
//        print ("Before layout frame is \(iceView.frame.width) \(iceView.frame.height)")
//
//        self.view.layoutSubviews()
//        print ("After layout frame is \(iceView.frame.width) \(iceView.frame.height)")
//    }
    
    // this will keep the iPhone in landscape mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
        //observer?.invalidate()
    }
    
    func updateViewFromModel () {
        clearIceView()
        guard let linescore = scheduleResults?.liveData.linescore else {return}
        guard let game = scheduleResults?.gameData.teams else {return}
        guard let allPlays = scheduleResults?.liveData.plays.allPlays else {return}
        guard let playsArray = scheduleResults?.liveData.plays.playsByPeriod else {return}
        homeTeam = game.home.triCode
        awayTeam = game.away.triCode

        setTitle()
        updatePeriodButtons (playsArray.count, scheduleResults?.gameData.game.type ?? .regularSeason)
        if linescore.periods.count != 0 {
            setTeamLogos()
            setScore(from: linescore)
            setShots(from: linescore)
        }
        let xFactor = iceView.frame.width / 200.0
        let yFactor = iceView.frame.height / 85.0
        //print ("the frame \(iceView.frame.width) \(iceView.frame.height)")

        if playsArray.count > 0 {
            for playNumber in playsArray[period-1].startIndex ... playsArray[period-1].endIndex {
                
                let aPlay = allPlays[playNumber]
                let event = aPlay.result.eventTypeID
                if event == .goal || event == .shot || (event == .missedShot && period == 5) {
                    // convert from the NHL coordinates to the views coordinates
                    let xConverted = (CGFloat (aPlay.coordinates.x ?? 0) + 100) * xFactor
                    let yConverted = (42.5 - (CGFloat (aPlay.coordinates.y ?? 0))) * yFactor
                    guard let team = aPlay.team?.triCode else {return}
                    draw (event, for: team, at: xConverted, and: yConverted)
                }
            }
        }
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    func setShots (from  linescore: Linescore) {
        shotsHomeTeam.text = homeTeam?.rawValue
        shotsVisitorTeam.text = awayTeam?.rawValue
        var shotsArray = [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]
        var period = 0
        for periodInfo in linescore.periods{
            shotsArray[0][period] += periodInfo.home.shotsOnGoal
            shotsArray[0][4] += periodInfo.home.shotsOnGoal
            shotsArray[1][period] += periodInfo.away.shotsOnGoal
            shotsArray[1][4] += periodInfo.away.shotsOnGoal
            if period < 3 {
                period += 1
            }
        }
        shotsHome1st.text = "\(shotsArray [0] [0])"
        shotsHome2nd.text = "\(shotsArray [0] [1])"
        shotsHome3rd.text = "\(shotsArray [0] [2])"
        shotsHomeOT.text = "\(shotsArray [0] [3])"
        shotsHomeTotal.text = "\(shotsArray [0] [4])"
        shotsVisitor1st.text = "\(shotsArray [1] [0])"
        shotsVisitor2nd.text = "\(shotsArray [1] [1])"
        shotsVisitor3rd.text = "\(shotsArray [1] [2])"
        shotsVisitorOT.text = "\(shotsArray [1] [3])"
        shotsVisitorTotal.text = "\(shotsArray [1] [4])"
        if linescore.periods.count > 3 {
            shotsHomeOT.isHidden = false
            shotsVisitorOT.isHidden = false
            shotsOTLabel.isHidden = false

        } else {
            shotsHomeOT.isHidden = true
            shotsVisitorOT.isHidden = true
            shotsOTLabel.isHidden = true
        }
    }
    
    func setScore (from  linescore: Linescore) {
        scoreHomeTeam.text = homeTeam?.rawValue
        scoreVisitorTeam.text = awayTeam?.rawValue
        var goalsArray = [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]
        var period = 0
        for periodInfo in linescore.periods{
            goalsArray[0][period] += periodInfo.home.goals
            goalsArray[0][4] += periodInfo.home.goals
            goalsArray[1][period] += periodInfo.away.goals
            goalsArray[1][4] += periodInfo.away.goals
            if period < 3 {
                period += 1
            }
        }
        scoreHome1st.text = "\(goalsArray [0] [0])"
        scoreHome2nd.text = "\(goalsArray [0] [1])"
        scoreHome3rd.text = "\(goalsArray [0] [2])"
        scoreHomeOT.text = "\(goalsArray [0] [3])"
        scoreHomeTotal.text = "\(goalsArray [0] [4])"
        scoreVisitor1st.text = "\(goalsArray [1] [0])"
        scoreVisitor2nd.text = "\(goalsArray [1] [1])"
        scoreVisitor3rd.text = "\(goalsArray [1] [2])"
        scoreVisitorOT.text = "\(goalsArray [1] [3])"
        scoreVisitorTotal.text = "\(goalsArray [1] [4])"
        if linescore.periods.count > 3 {
            scoreHomeOT.isHidden = false
            scoreVisitorOT.isHidden = false
            scoreOTLabel.isHidden = false
            
        } else {
            scoreHomeOT.isHidden = true
            scoreVisitorOT.isHidden = true
            scoreOTLabel.isHidden = true
        }

    }
    func setTeamLogos () {
        // there was a game that didnt have a rink side in it and some were wrong!!!!
        var rinkSideIndex = 0
        if period == 5 && scheduleResults?.liveData.linescore?.hasShootout ?? false {
            rinkSideIndex = 0
        } else {
            rinkSideIndex = period - 1
        }
        if  let homeRinkside = scheduleResults?.liveData.linescore?.periods[rinkSideIndex].home.rinkSide {
            let awayTeamName = scheduleResults?.gameData.teams.away.name ?? "unkown"
            let homeTeamName = scheduleResults?.gameData.teams.home.name ?? "unkown"

            if homeRinkside == "right"{
                leftTeam.image = UIImage (named: awayTeamName)
                rightTeam.image = UIImage (named: homeTeamName)
            } else {
                leftTeam.image = UIImage (named: homeTeamName)
                rightTeam.image = UIImage (named: awayTeamName)
            }
        } else {
            // if the rinkside is not defined in the JSON default to this, seems to only happen with Vegas????
            let awayTeamName = scheduleResults?.gameData.teams.away.name ?? "unkown"
            let homeTeamName = scheduleResults?.gameData.teams.home.name ?? "unkown"
            if period % 2 == 0 {
                leftTeam.image = UIImage (named: homeTeamName)
                rightTeam.image = UIImage (named: awayTeamName)

            } else {
                leftTeam.image = UIImage (named: awayTeamName)
                rightTeam.image = UIImage (named: homeTeamName)
            }
        }
    }
    
    func setTitle () {
        let awayName = scheduleResults?.gameData.teams.away.teamName ?? "unknown"
        let homeName = scheduleResults?.gameData.teams.home.teamName ?? "unknown"
        guard let statusCode = scheduleResults?.gameData.status.statusCode else {return}
        let detailedState = scheduleResults?.gameData.status.detailedState ?? "unknown"
        
        let homeScore = scheduleResults?.liveData.linescore?.teams.home.goals ?? 99
        let awayScore = scheduleResults?.liveData.linescore?.teams.away.goals ?? 99

        switch statusCode {
        case .final, .unofficial, .gameOver :
            self.navigationItem.title = "\(awayName) \(awayScore) at \(homeName) \(homeScore) \(detailedState)"
        case .inProgress, .inProgressCritical:
            let period = scheduleResults?.liveData.linescore?.currentPeriodOrdinal ?? "error"
            let timeRemaining = scheduleResults?.liveData.linescore?.currentPeriodTimeRemaining ?? "error"
            self.navigationItem.title = "\(awayName)  \(awayScore) at \(homeName)  \(homeScore) \(period) \(timeRemaining)"
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(autoFetchData), userInfo: nil, repeats: false)
        case .pregame, .scheduled:
             self.navigationItem.title = "\(awayName) at \(homeName)"
        }
    }
    
    func clearIceView () {
        for theView in iceView.subviews {
            theView.removeFromSuperview()
        }
    }
    
    func updatePeriodButtons (_ periods: Int, _ gameType: GameType) {
        switch periods {
        case 0:
            firstPeriod.isEnabled = false
            firstPeriod.isSelected = false
            firstPeriod.alpha = 0.25
            secondPeriod.isEnabled = false
            secondPeriod.alpha = 0.25
            thirdPeriod.isEnabled = false
            thirdPeriod.alpha = 0.25
            overtime.isHidden = true
            overtime.isEnabled = false
            shootout.isHidden = true
            shootout.isEnabled = false

        case 1:
            firstPeriod.isEnabled = true
            firstPeriod.alpha = 1.0
            secondPeriod.isEnabled = false
            secondPeriod.alpha = 0.25
            thirdPeriod.isEnabled = false
            thirdPeriod.alpha = 0.25
            overtime.isEnabled = false
            overtime.isHidden = true
            shootout.isEnabled = false
            shootout.isHidden = true
        case 2:
            firstPeriod.isEnabled = true
            firstPeriod.alpha = 1.0
            secondPeriod.isEnabled = true
            secondPeriod.alpha = 1.0
            thirdPeriod.isEnabled = false
            thirdPeriod.alpha = 0.25
            overtime.isEnabled = false
            overtime.isHidden = true
            shootout.isEnabled = false
            shootout.isHidden = true
        case 3:
            firstPeriod.isEnabled = true
            firstPeriod.alpha = 1.0
            secondPeriod.isEnabled = true
            secondPeriod.alpha = 1.0
            thirdPeriod.isEnabled = true
            thirdPeriod.alpha = 1.0
            overtime.isEnabled = false
            overtime.isHidden = true
            shootout.isEnabled = false
            shootout.isHidden = true
        case 4:
            firstPeriod.isEnabled = true
            firstPeriod.alpha = 1.0
            secondPeriod.isEnabled = true
            secondPeriod.alpha = 1.0
            thirdPeriod.isEnabled = true
            thirdPeriod.alpha = 1.0
            overtime.isEnabled = true
            overtime.isHidden = false
            shootout.isEnabled = false
            shootout.isHidden = true
        case 5:
            firstPeriod.isEnabled = true
            firstPeriod.alpha = 1.0
            secondPeriod.isEnabled = true
            secondPeriod.alpha = 1.0
            thirdPeriod.isEnabled = true
            thirdPeriod.alpha = 1.0
            overtime.isEnabled = true
            overtime.isHidden = false
            shootout.isEnabled = true
            shootout.isHidden = false
            if gameType == .playoff {
                shootout.setTitle("Overtime(2)", for: .normal)
            }
        default:
            firstPeriod.isEnabled = true
            firstPeriod.alpha = 1.0
            secondPeriod.isEnabled = true
            secondPeriod.alpha = 1.0
            thirdPeriod.isEnabled = true
            thirdPeriod.alpha = 1.0
            overtime.isEnabled = true
            overtime.isHidden = false
            shootout.isEnabled = true
            shootout.isHidden = false
        }
        
    }
    
    func getTeamColor (team: TriCodeEnum) -> UIColor {
        switch team {
        case .Anaheim:
            return UIColor(hexString: anaheim)
        case .Arizona:
            return UIColor(hexString: arizona)
        case .Boston:
            return UIColor(hexString: boston)
        case .Buffalo:
            return UIColor(hexString: buffalo)
        case .Calgary:
            return UIColor(hexString: calgary)
        case .Carolina:
            return UIColor(hexString: carolina)
        case .Chicago:
            return UIColor(hexString: chicago)
        case .Colorado:
            return UIColor(hexString: colorado)
        case .Columbus:
            return UIColor(hexString: columbus)
        case .Dallas:
            return UIColor(hexString: dallas)
        case .Detroit:
            return UIColor(hexString: detroit)
        case .Edmonton:
            return UIColor(hexString: edmonton)
        case .Florida:
            return UIColor(hexString: florida)
        case .LosAngeles:
            return UIColor(hexString: losAngeles)
        case .Minnesota:
            return UIColor(hexString: minnesota)
        case .Montreal:
            return UIColor(hexString: montreal)
        case .Nashville:
            return UIColor(hexString: nashville)
        case .Islanders:
            return UIColor(hexString: newYorkIslanders)
        case .NewJersey:
            return UIColor(hexString: newJersey)
        case .Rangers:
            return UIColor(hexString: newYork)
        case .Ottawa:
            return UIColor(hexString: ottawa )
        case .Philadelphia:
            return UIColor(hexString: philadelphia)
        case .Pittsburgh:
            return UIColor(hexString: pittsburgh)
        case .SanJose:
            return UIColor(hexString: sanJose)
        case .StLouis:
            return UIColor(hexString: stLouis)
        case .TampaBay:
            return UIColor(hexString: tampaBay)
        case .Toronto:
            return UIColor(hexString: toronto)
        case .Vancouver:
            return UIColor(hexString: vancouver)
        case .Vegas:
            return UIColor(hexString: vegas)
        case .Washington:
            return UIColor(hexString: washington)
        case .Winnipeg:
            return UIColor(hexString: winnipeg)

        // Old Teams
        case .Atlanta:
            return UIColor(hexString: atlanta)
        case .AtlantaFlames:
            return UIColor(hexString: calgary)
        case .ColRock:
                return UIColor(hexString: colorado)
        case.Hartford:
            return UIColor(hexString: hartford)
        case .MinnesotaNS:
            return UIColor(hexString:minnestotaNS)
        case .Winnipeg92:
            return UIColor(hexString: winnipeg)
        case .Phoenix:
            return UIColor(hexString: arizona)
        case .Quebec:
            return UIColor(hexString: quebec)
        default:
            return .blue
//        case .California:
//        case .Cleveland:
//        case .KansasCity:
//        case .Oakland:
        }
    }
    
    func draw (_ event: EventTypeID, for team:TriCodeEnum, at x:CGFloat, and y:CGFloat) {
        
        let dot = UIView(frame: CGRect(x: x-6, y: y-6, width: 12, height: 12))
        dot.backgroundColor = getTeamColor(team: team)
        dot.alpha = 1.0
        if team == homeTeam {
            dot.layer.cornerRadius = 6.0
        } else {
            dot.layer.cornerRadius = 3.0
            dot.transform = dot.transform.rotated(by: .pi/4)
        }

        if event == .goal {
            let goal = UIView(frame: CGRect(x: 3, y: 3, width: 6 ,height: 6))
            goal.backgroundColor = .white
            goal.layer.cornerRadius = 3
            dot.addSubview(goal)
            UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
                dot.transform = CGAffineTransform (scaleX: 2.0, y: 2.0)
            })
            
        }
        iceView.addSubview(dot)
        //iceView.layoutSubviews()
    }
    
    @IBAction func periodSelected(_ sender: UIButton) {
        timer.invalidate()
        period = sender.tag
        switch period{
        case 1:
            firstPeriod.isSelected = true
            secondPeriod.isSelected = false
            thirdPeriod.isSelected = false
            overtime.isSelected = false
            shootout.isSelected = false
        case 2:
            firstPeriod.isSelected = false
            secondPeriod.isSelected = true
            thirdPeriod.isSelected = false
            overtime.isSelected = false
            shootout.isSelected = false
        case 3:
            firstPeriod.isSelected = false
            secondPeriod.isSelected = false
            thirdPeriod.isSelected = true
            overtime.isSelected = false
            shootout.isSelected = false
        case 4:
            firstPeriod.isSelected = false
            secondPeriod.isSelected = false
            thirdPeriod.isSelected = false
            overtime.isSelected = true
            shootout.isSelected = false
        case 5:
            firstPeriod.isSelected = false
            secondPeriod.isSelected = false
            thirdPeriod.isSelected = false
            overtime.isSelected = false
            shootout.isSelected = true
            
        default:
            break
        }
        updateViewFromModel()
    }

    
    //MARK: getting data methods
    @objc func autoFetchData () {
        fetchGameDetail { self.updateViewFromModel()}
    }
    
    func fetchGameDetail (completed:@escaping ()->() ) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        let urlString = "\(domainURLString)\(gameDetailLink ?? "")"
        print ("fetchGameDetail: ", urlString)
        guard let url = URL(string: urlString) else { return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil {
                do {
                    self.scheduleResults = try JSONDecoder().decode(Game.self, from: data!)
                    DispatchQueue.main.async {
                        completed ()
                    }
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
            }.resume()
    }
}

//MARK: Navigation controller extensions
// this will keep the iPhone in landscape mode
extension UINavigationController {
    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }

    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }

}
