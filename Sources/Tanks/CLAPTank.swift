import Foundation

class CLAPTank: Tank {

	enum Mode {
		case GUNRUN, CHILL
	}

	private var turn = 0
	private var mode: Mode = .GUNRUN
	private var chillin = false


	override init (row: Int, col: Int, energy: Int, id: String, instructions: String) {
		super.init(row: row, col: col, energy: energy, id: id, instructions: instructions)
	}

	override func computePreActions() {
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

	override func computePostActions() {

		switch mode {
			case .CHILL: break
			case .GUNRUN: 
				for i in radarResults! {
					if !isFriendly(tank: i){
						addPostAction(postAction: MissileAction(power: ((i.energy) / 10) + 300, target: i.position))
						break
					}
				}
				addPostAction(postAction: MoveAction(distance: 2, direction: randomDirection()))
			default: break;
		}
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