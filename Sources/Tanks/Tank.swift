import Foundation

class Tank: GameObject {

	enum Mode {
		case GUNRUN, CHILL
	}

	private (set) var shields: Int = 0
	var radarResults: [RadarResult]?
	private var receivedMessage: String?
	private (set) var preActions = [Actions : PreAction]()
	private (set) var postActions = [Actions: PostAction]()
	private let initialInstructions: String?
	private var turn = 0
	private var mode: Mode = .GUNRUN
	private var chillin = false


	init (row: Int, col: Int, energy: Int, id: String, instructions: String) {
		initialInstructions = instructions
		super.init(row: row, col: col, objectType: .Tank, energy: energy, id: id)
	}

	final func clearActions() {
		preActions = [Actions : PreAction]()
		postActions = [Actions: PostAction]()
	}

	final func receiveMessage (message: String?) {receivedMessage = message}

	func computePreActions() {
		turn += 1
		if let r = radarResults {
			if turn >= 100 || chillin || r.count == 0{
				mode = .CHILL
				chillin = true
			}
		}
		else {
			mode = .GUNRUN
		}

		switch mode{
			case .CHILL: break
			case .GUNRUN: addPreAction(preAction: RadarAction(range: 4))
			default: break
		}
	}

	func computePostActions() {

		switch mode {
			case .CHILL: break
			case .GUNRUN: 
				for i in radarResults! {
					if !isFriendly(tank: i){
						addPostAction(postAction: MissileAction(power: (i.energy) / 10 + 30, target: i.position))
						break
					}
				}
				addPostAction(postAction: MoveAction(distance: 2, direction: randomDirection()))
			default: break;
		}
	}

	final func addPreAction (preAction: PreAction) {
		preActions[preAction.action] = preAction
	}

	final func addPostAction (postAction: PostAction) {
		postActions[postAction.action] = postAction
	}

	final func setShields (amount: Int) {shields = amount}

	final func setRadarResult(radarResults: [RadarResult]!) {
		self.radarResults = radarResults
	}

	final func setReceivedMessage(receivedMessage: String!) {
		self.receivedMessage = receivedMessage
	}

	func randomDirection () -> Direction {
		let dirNum = Int(random() % 8)
		var dir: Direction = .N
		if dirNum == 0 {dir = .N}
		else if dirNum == 1 {dir = .NE}
		else if dirNum == 2 {dir = .E}
		else if dirNum == 3 {dir = .SE}
		else if dirNum == 4 {dir = .S}
		else if dirNum == 5 {dir = .SW}
		else if dirNum == 6 {dir = .W}
		else {dir = .NW}
		return dir
	}

	func isFriendly(tank: RadarResult) -> Bool{
		return tank.id == id
	}

}