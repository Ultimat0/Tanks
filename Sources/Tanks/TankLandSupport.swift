import Foundation

extension TankWorld {

	func findAllGameObjects () -> [GameObject] {
		var gameObjects = [GameObject]()
		for row in 0..<numberRows {
			for col in 0..<numberCols {
				if let gameObject = grid[row][col]  {
					gameObjects.append(gameObject)
				}
			}
		}
		return gameObjects
	}

	/*func handleRadar(tank: Tank) {
		guard let radarAction = tank.preActions[.Radar] else {return}
		actionRunRadar (tank: tank, radarAction: radarAction as! RadarAction)
	}*/

	func handleMove(tank: Tank) {
		guard let moveAction = tank.postActions[.Move] else {return}
		actionRunMove(tank: tank, moveAction: moveAction as! MoveAction)
	}

	func handleTank(tank: Tank) {
		tank.computePreActions()
		tank.computePostActions()
		handleMove(tank: tank)
		tank.clearActions()
	}

	func handleRover(rover: Rover) {
		if let dir = rover.direction {

		}
	}


	func actionRunMove(tank: Tank, moveAction: MoveAction) {
		
		let newPos: Position = newPosition(position: tank.position, direction: moveAction.direction, distance: moveAction.distance)

		if isPositionEmpty(newPos) {
			grid[tank.position.row][tank.position.col] = nil
			tank.setPosition(newPosition: newPos)
			grid[tank.position.row][tank.position.col] = tank
		}
	}

	func newPosition (position: Position, direction: Direction, distance: Int) -> Position {
		var rowOffset = 0
		var colOffset = 0
		switch direction {
			case .N: 
				rowOffset += distance
			case .NE:
				rowOffset += distance
				colOffset += distance
			case .E:
				colOffset += distance
			case .SE:
				rowOffset -= distance
				colOffset += distance
			case .S:
				rowOffset -= distance
			case .SW:
				rowOffset -= distance
				colOffset -= distance
			case .W:
				colOffset -= distance
			case .NW:
				rowOffset += distance
				colOffset -= distance
		}

		let newPos: Position = Position(row: (position.row - rowOffset), col: (position.col + colOffset))
		if isValidPosition(newPos) {
			return newPos
		}
		else {
			return position
		}
	}

	func isDead (_ gameObject: GameObject) -> Bool {
		return gameObject.energy <= 0
	}

	func randomizeGameObjects<T>(_ gameObjects: inout [T]) {

		var last = gameObjects.count - 1

		while last > 0 {

			srandom(UInt32(time(nil)))
			let rand = Int(random() % (last + 1))
			gameObjects.swapAt(last, rand)
			last -= 1

		}

	}
}