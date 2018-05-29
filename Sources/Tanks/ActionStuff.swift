protocol Action: CustomStringConvertible {
	var action: Actions {get}
	var description: String {get}
}

protocol PreAction: Action {
	
}

protocol PostAction: Action {
	
}

enum Actions {
	case Move, Shields, SendMessage, ReceiveMessage, Missile, Radar, DropMine
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

struct ShieldAction: PreAction {
	let action: Actions
	let power: Int
	var description: String {
		return "\(action) \(power)"
	}

	init (power: Int) {
		action = .Shields
		self.power = power
	}	
}

struct MissileAction: PostAction {
	let action: Actions
	let power: Int
	let target: Position
	var description: String {
		return "\(action) \(power) \(target)"
	}

	init (power: Int, target: Position) {
		action = .Missile
		self.power = power
		self.target = target
	}
}

struct SendMessageAction: PreAction {
	let action: Actions
	let key: String
	let message: String
	var description: String {
		return "\(action) \(key) \(message)"
	}

	init(key: String, message: String) {
		action = .SendMessage
		self.key = key
		self.message = message
	}
}

struct ReceiveMessageAction: PreAction {
	let action: Actions
	let key: String
	var description: String {
		return "\(action) \(key)"
	}

	init(key: String, message: String) {
		action = .SendMessage
		self.key = key
	}
}

struct DropMineAction: PostAction {
	let action: Actions
	let isRover: Bool
	let power: Int
	let dropDirection: Direction?
	let moveDirection: Direction?
	var description: String {
		let dropDirectionMessage = (dropDirection == nil) ? "drop direction is random" : "\(dropDirection!)"
		let moveDirectionMessage = (moveDirection == nil) ? "move direction is random" : "\(moveDirection!)"
		return "\(action) \(power) \(dropDirectionMessage) \(isRover) \(moveDirectionMessage)"
	}

	init (power: Int, isRover: Bool = false, dropDirection: Direction? = nil, moveDirection: Direction? = nil) {
		action = .DropMine
		self.isRover = isRover
		self.dropDirection = dropDirection
		self.moveDirection = moveDirection
		self.power = power
	}
}
