struct Constants {
	let initialTankEnergy = 100000
	let costOfRadarByUnitsDistance = [0, 100, 200, 400, 800, 1600, 3200, 6400, 12400]
	let costOfSendingMessage = 100
	let costOfReceivingMessage = 100
	let costOfReleasingMine = 250
	let costOfReleasinRover = 500
	let costOfLaunchingMissile = 1000
	let costOfFlyingMissilePerUnitDistance = 200
	let costOfMovingTankPerUnitDistance = [100, 300, 600]
	let costOfMovingRover = 50
	let costLifeSupportTank = 100
	let costLifeSupportRover = 40
	let costLifeSupportMine = 20
	let missileStrikeMultiple = 10
	let missileStrikeMultipleCollateral = 3
	let mineStrikeMultiple = 5
	let shieldPowerMultiple = 8
	let missileStrikeEnergyTransferFraction = 4
}

struct Position: CustomStringConvertible {
	
	let row: Int
	let col: Int
	//let legitRow: Int

	init (row: Int, col: Int) {
		self.row = row 
		self.col = col
		//self.legitRow = 9 - row
	}

	var description: String {
		return "(\(col), \(row))"
	}
}

enum Direction {
	case N, NE, E, SE, S, SW, W, NW
}