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

	func handleShields(tank: Tank) {
		guard let shieldAction = tank.preActions[.Shields] else {return}
		actionRunShields(tank: tank, shieldAction: shieldAction as! ShieldAction)
	}

	func handleTankPre(tank: Tank) {
		tank.computePreActions()
		let old = tank.energy
		logger.addLog(tank, "LIFE SUPPORT")
		tank.useEnergy(amount: constants.costLifeSupportTank)
		energyDrop(tank, old, tank.energy)
		handleRadar(tank: tank)
		handleShields(tank: tank)
	}

	func handleTankPost(tank: Tank) {
		tank.computePostActions()
		handleMove(tank: tank)
		handleMissile(tank: tank)
		tank.clearActions()
	}


	func handleRoverPre(rover: Rover) {
		let old = rover.energy
		logger.addLog(rover, "LIFE SUPPORT")
		rover.useEnergy(amount: constants.costLifeSupportRover)
		energyDrop(rover, old, rover.energy)
	}

	func handleRoverPost(rover: Rover) {
		if let dir = rover.direction {
			if isEnergyAvailable(gameObject: rover, cost: constants.costOfMovingRover) {
				grid[rover.position.row][rover.position.col] = nil
				let newPos = newPosition(position: rover.position, direction: dir, distance: 1)
				let old = rover.energy
				let oldPos = rover.position
				if newPos.row != rover.position.row || newPos.col != rover.position.col {
					rover.useEnergy(amount: constants.costOfMovingRover)
					rover.setPosition(newPosition: newPos)
					logger.addLog(rover, "Moved from \(oldPos) to \(rover.position)")
					energyDrop(rover, old, rover.energy)
				}
				if !isPositionEmpty(newPos) {
					logger.addLog(rover, "Collided with grid[rover.position.row][rover.position.col]!.id")				
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
				let oldPos = rover.position
				rover.setPosition(newPosition: newPos)
				logger.addLog(rover, "Moved from \(oldPos) to \(rover.position)")
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
		let old = mine.energy
		mine.useEnergy(amount: constants.costLifeSupportMine)
		energyDrop(mine, old, mine.energy)
	}


	func actionRunShields (tank: Tank, shieldAction: ShieldAction) {
		if isEnergyAvailable(gameObject: tank, cost: shieldAction.power) {
			tank.setShields(amount: (constants.shieldPowerMultiple * shieldAction.power))
			logger.addLog(tank, "Setting shields to \(constants.shieldPowerMultiple * shieldAction.power)")
			tank.useEnergy(amount: shieldAction.power)
		}
	}


	func actionRunMove(tank: Tank, moveAction: MoveAction) {
		
		let newPos: Position = newPosition(position: tank.position, direction: moveAction.direction, distance: moveAction.distance)

		let cost = constants.costOfMovingTankPerUnitDistance[moveAction.distance - 1]

		if isPositionEmpty(newPos) && !containsTank(newPos) && isEnergyAvailable(gameObject: tank, cost: cost){
		 	let old = tank.energy
		 	let oldPos = tank.position
			grid[tank.position.row][tank.position.col] = nil
			tank.setPosition(newPosition: newPos)
			grid[tank.position.row][tank.position.col] = tank
			logger.addLog(tank, "Moving from \(oldPos) to \(tank.position)")
			tank.useEnergy(amount: cost)
			energyDrop(tank, old, tank.energy)
		}
	}

	func actionRunRadar(tank: Tank, radarAction: RadarAction) {
		if isEnergyAvailable(gameObject: tank, cost: constants.costOfRadarByUnitsDistance[radarAction.range - 1]) {
			var results: [RadarResult] = [RadarResult]()
			for gameObject in gameObjectsInRadius(position: tank.position, radius: radarAction.range) {
				results.append(RadarResult(gameObject: gameObject))
			}
			tank.setRadarResult(radarResults: results)
			let old = tank.energy
			logger.addLog(tank, "Running radar \(radarAction.range)")
			tank.useEnergy(amount: constants.costOfRadarByUnitsDistance[radarAction.range - 1])
			energyDrop(tank, old, tank.energy)
		}
	}

	func actionRunMissile(tank: Tank, missileAction: MissileAction) {

		var cost = 1000
		cost += Int(sqrt(pow(Double(tank.position.row - missileAction.target.row), 2.0) + pow(Double(tank.position.col - missileAction.target.col), 2.0))) * 200
		if isEnergyAvailable(gameObject: tank, cost: cost) {
			logger.log("**********MISSILE STRIKE RESULTS \(tank.id) hits \(missileAction.target)")
			logger.addLog(tank, "strikes location \(missileAction.target) with \(missileAction.power) energy")
			if !isPositionEmpty(missileAction.target) {
				let go = grid[missileAction.target.row][missileAction.target.col]!
				if go.objectType == .Tank {
					let tanku = go as! Tank
					let tankEnergy = go.energy
					go.useEnergy(amount: (missileAction.power * constants.missileStrikeMultiple - tanku.shields))
					if (go.energy < 1) {
						tank.addEnergy(amount: Int(tankEnergy/constants.missileStrikeEnergyTransferFraction))
						grid[go.position.row][go.position.col] = nil
					}
					energyDrop(go, tankEnergy, go.energy)
				}
				else {grid[missileAction.target.row][missileAction.target.col] = nil}
			}
			for go in gameObjectsInRadius(position: missileAction.target, radius: 1) {
				if go.objectType == .Tank {
					let tankEnergy = go.energy
					let tanku = go as! Tank
					go.useEnergy(amount: missileAction.power * constants.missileStrikeMultiple / 4 - tanku.shields)
					if (go.energy < 0) {
						tank.addEnergy(amount: Int(tankEnergy/constants.missileStrikeEnergyTransferFraction))
						grid[missileAction.target.row][missileAction.target.col] = nil
					}
					energyDrop(go, tankEnergy, go.energy)
				}
				else {grid[missileAction.target.row][missileAction.target.col] = nil}
			}
			logger.log("**********END MISSILE STRIKE RESULTS")
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

	func energyDrop(_ object: GameObject, _ oldEnergy: Int, _ energy: Int) {
        logger.addLog(object, "Energy drop from \(oldEnergy) to \(energy)")
	}

}