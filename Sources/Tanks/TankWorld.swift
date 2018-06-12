import Foundation

public class TankWorld {
	
	var grid: [[GameObject?]]
	var turn: Int = 0
	var gameOver = false
	let numberCols = 15
	let numberRows = 15
	var numberLivingTanks = 0
	var lastLivingTank: Tank? = nil
	let constants: Constants = Constants()
	var logger = Logger()

	init () {

		grid = Array(repeating: Array(repeating: nil, count: numberCols), count: numberRows)
		srandom(UInt32(time(nil)))

	}

	func setWinner(lastTankStanding: Tank) {
		gameOver = true
		lastLivingTank = lastTankStanding
	}

	func populateTankWorld () {
		addGameObject(gameObject: CLAPTank(row: 5, col: 5, energy: 100000, id: "CLAP", instructions: ""))
		addGameObject(gameObject: CLAPTank(row: 4, col: 7, energy: 100000, id: "CLAP", instructions: ""))
		addGameObject(gameObject: SampleTank(row: 14, col: 14, energy: 100000, id: "OPOP", instructions: ""))
		addGameObject(gameObject: SampleTank(row: 5, col: 11, energy: 100000, id: "BOIO", instructions: ""))
		addGameObject(gameObject: SampleTank(row: 1, col: 8, energy: 100000, id: "OKOK", instructions: ""))
		addGameObject(gameObject: SampleTank(row: 8, col: 8, energy: 100000, id: "AIDS", instructions: ""))
		addGameObject(gameObject: SampleTank(row: 12, col: 4, energy: 100000, id: "SNIK", instructions: ""))
		addGameObject(gameObject: SampleTank(row: 10, col: 10, energy: 100000, id: "OPOP", instructions: ""))
		addGameObject(gameObject: SampleTank(row: 9, col: 2, energy: 100000, id: "BOIO", instructions: ""))
		addGameObject(gameObject: SampleTank(row: 3, col: 14, energy: 100000, id: "OKOK", instructions: ""))
		addGameObject(gameObject: SampleTank(row: 1, col: 1, energy: 100000, id: "AIDS", instructions: ""))
		addGameObject(gameObject: SampleTank(row: 3, col: 4, energy: 100000, id: "SNIK", instructions: ""))

	}

	func addGameObject (gameObject: GameObject) {
		logger.addLog(gameObject, "Added to TankLand")
		grid[gameObject.position.row] [gameObject.position.col] = gameObject
		if gameObject.objectType == .Tank {numberLivingTanks += 1}
	}

	
	func doTurn() {
		var allObjects = findAllGameObjects()
		randomizeGameObjects(&allObjects)

		for gameObject in allObjects {
			switch gameObject.objectType {
				case .Tank: handleTankPre(tank: (gameObject as! Tank))
				case .Rover: handleRoverPre(rover: gameObject as! Rover)
				case .Mine: break
			}
		}

		for gameObject in allObjects {
			switch gameObject.objectType {
				case .Tank: handleTankPost(tank: (gameObject as! Tank))
				case .Rover: handleRoverPost(rover: gameObject as! Rover)
				case .Mine: break
			}
		}
		
		turn += 1
	}

	func runOneTurn() {
		doTurn()
		print(gridReport())
	}

	func driver() {
		populateTankWorld()
		print(gridReport())
		/*while !gameOver {
			runOneTurn()
		}*/
		while true {
			runOneTurn()
			readLine()
		}
		
	}


}