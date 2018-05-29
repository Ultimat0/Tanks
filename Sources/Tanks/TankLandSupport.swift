import Foundation

extension TankWorld {

	
	func handleRadar(tank: Tank) {
		guard let radarAction = tank.preActions[.Radar] else {return}
		actionRunRadar (tank: tank, radarAction: radarAction as! RadarAction)
	}

	func handleMove(tank: Tank) {
		guard let moveAction = tank.postActions[.Move] else {return}
		actionRunMove(tank: tank, moveAction: moveAction as! MoveAction)
	}

	func handleMissile(tank: Tank) {
		guard let missileAction = tank.postActions[.Missile] else {return}
		actionRunMissile(tank: tank, missileAction: missileAction as! MissileAction)
	}

	func handleTankPre(tank: Tank) {
		tank.computePreActions()
		tank.useEnergy(amount: constants.costLifeSupportTank)
		handleRadar(tank: tank)
		//ADD PREACTION STUFF
	}

	func handleTankPost(tank: Tank) {
		tank.computePostActions()
		handleMove(tank: tank)
		handleMissile(tank: tank)
		tank.clearActions()
	}


	func handleRoverPre(rover: Rover) {
		rover.useEnergy(amount: constants.costLifeSupportRover)
	}

	func handleRoverPost(rover: Rover) {
		if let dir = rover.direction {
			if isEnergyAvailable(gameObject: rover, cost: constants.costOfMovingRover) {
				grid[rover.position.row][rover.position.col] = nil
				let newPos = newPosition(position: rover.position, direction: dir, distance: 1)
				if newPos.row != rover.position.row || newPos.col != rover.position.col {rover.useEnergy(amount: constants.costOfMovingRover)}
				if !isPositionEmpty(newPos) {
					grid[rover.position.row][rover.position.col]!.useEnergy(amount: rover.energy)
				}
				else {
					grid[newPos.row][newPos.col] = rover
				}
			}
		}
		else {
			if isEnergyAvailable(gameObject: rover, cost: constants.costOfMovingRover) {
				grid[rover.position.row][rover.position.col] = nil
				let newPos = newPosition(position: rover.position, direction: randomDirection(), distance: 1)
				rover.setPosition(newPosition: newPos)
				if !isPositionEmpty(newPos) {
					if (grid[rover.position.row][rover.position.col]!.objectType == .Tank) {
						grid[rover.position.row][rover.position.col]!.useEnergy(amount: rover.energy)
					}
					else {
						grid[rover.position.row][rover.position.col] = nil
					}
				}
				else {
					grid[newPos.row][newPos.col] = rover
				}
			}
		}	
	}

	func handleMinePre (mine: Mine) {
		mine.useEnergy(amount: constants.costLifeSupportMine)
	}

	func actionRunMove(tank: Tank, moveAction: MoveAction) {
		
		let newPos: Position = newPosition(position: tank.position, direction: moveAction.direction, distance: moveAction.distance)

		let cost = constants.costOfMovingTankPerUnitDistance[moveAction.distance - 1]

		if isPositionEmpty(newPos) && !containsTank(newPos) && isEnergyAvailable(gameObject: tank, cost: cost){
			grid[tank.position.row][tank.position.col] = nil
			tank.setPosition(newPosition: newPos)
			grid[tank.position.row][tank.position.col] = tank
			tank.useEnergy(amount: cost)
		}
	}

	func actionRunRadar(tank: Tank, radarAction: RadarAction) {
		if isEnergyAvailable(gameObject: tank, cost: constants.costOfRadarByUnitsDistance[radarAction.range - 1]) {
			var results: [RadarResult] = [RadarResult]()
			for gameObject in gameObjectsInRadius(position: tank.position, radius: radarAction.range) {
				results.append(RadarResult(gameObject: gameObject))
			}
			tank.setRadarResult(radarResults: results)
			tank.useEnergy(amount: constants.costOfRadarByUnitsDistance[radarAction.range - 1])
		}
	}

	func actionRunMissile(tank: Tank, missileAction: MissileAction) {
		if !isPositionEmpty(missileAction.target) {
			let go = grid[missileAction.target.row][missileAction.target.col]!
			if go.objectType == .Tank {
				let tankEnergy = go.energy
				go.useEnergy(amount: missileAction.power * constants.missileStrikeMultiple)
				if (go.energy <= 0) {
					tank.addEnergy(amount: Int(tankEnergy/constants.missileStrikeEnergyTransferFraction))
					grid[missileAction.target.row][missileAction.target.col] = nil
				}
			}
			else {grid[missileAction.target.row][missileAction.target.col] = nil}
		}
		for go in gameObjectsInRadius(position: missileAction.target, radius: 1) {
			if go.objectType == .Tank {
				let tankEnergy = go.energy
				go.useEnergy(amount: missileAction.power * constants.missileStrikeMultiple / 4)
				if (go.energy <= 0) {
					tank.addEnergy(amount: Int(tankEnergy/constants.missileStrikeEnergyTransferFraction))
					grid[missileAction.target.row][missileAction.target.col] = nil
				}
			}
			else {grid[missileAction.target.row][missileAction.target.col] = nil}
		}
	}


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

	func randomizeGameObjects<T: GameObject>(_ gameObjects: inout [T]) {

		var last = gameObjects.count - 1

		while last > 0 {

			let rand = Int(random() % (last + 1))
			gameObjects.swapAt(last, rand)
			last -= 1

		}

	}

	
	func isEnergyAvailable(gameObject: GameObject, cost: Int) -> Bool {
		return gameObject.energy > cost
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


}