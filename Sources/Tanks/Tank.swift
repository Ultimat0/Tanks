import Foundation

class Tank: GameObject {

	private (set) var shields: Int = 0
	//private var radarResults: [RadarResult]?
	private var receivedMessage: String?
	private (set) var preActions = [Actions : PreAction]()
	private (set) var postActions = [Actions: PostAction]()
	private let initialInstructions: String?

	init (row: Int, col: Int, name: String, energy: Int, id: String, instructions: String) {
		initialInstructions = instructions
		super.init(row: row, col: col, objectType: .Tank, name: name, energy: energy, id: id)
	}

	final func clearActions() {
		preActions = [Actions : PreAction]()
		postActions = [Actions: PostAction]()
	}

	final func receiveMessage (message: String?) {receivedMessage = message}

	func computePreActions() {

	}

	func computePostActions() {
		srandom(UInt32(time(nil)))
		let dist = 1//Int(random() % 3)
		srandom(UInt32(time(nil)))
		let dirNum = Int(random() % 8)
		var dir: Direction = .N
		if dirNum == 0 {dir = .N}
		else if dirNum == 1 {dir = .NE}
		else if dirNum == 2 {dir = .E}
		else if dirNum == 3 {dir = .SE}
		else if dirNum == 4 {dir = .S}
		else if dirNum == 5 {dir = .SW}
		else if dirNum == 6 {dir = .W}
		else if dirNum == 7 {dir = .NW}
		addPostAction (postAction: MoveAction(distance: dist, direction: dir))
	}

	final func addPreAction (preAction: PreAction) {
		preActions[preAction.action] = preAction
	}

	final func addPostAction (postAction: PostAction) {
		postActions[postAction.action] = postAction
	}

	final func setShields (amount: Int) {shields = amount}

	/*final func setRadarResult(radarResults: [RadarResult]!) {
		self.radarResults = radarResults
	}*/

	final func setReceivedMessage(receivedMessage: String!) {
		self.receivedMessage = receivedMessage
	}
}