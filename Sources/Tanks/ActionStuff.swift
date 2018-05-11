protocol Action: CustomStringConvertible {
	var action: Actions {get}
	var description: String {get}
}

protocol PreAction: Action {
	
}

protocol PostAction: Action {
	
}

enum Actions {
	case Move, Shield, Message, Missile, Radar
}

struct MoveAction: PostAction {
	let action: Actions
	let distance: Int
	let direction: Direction
	var description: String {
		return "\(action) \(distance) \(direction)"
	}

	init(distance: Int, direction: Direction) {
		action = .Move
		self.distance = distance
		self.direction = direction
	}
}

struct RadarAction: PreAction {
	let action: Actions
	let range: Int
	var description: String {
		return "\(action) \(range)"
	}

	init(range: Int) {
		action = .Radar
		self.range = range
	}
}
