public class TankWorld {
	
	var grid: [[GameObject?]]
	var turn: Int = 0
	var gameOver = false
	let numberCols = 10
	let numberRows = 10
	var numberLivingTanks = 0
	var lastLivingTank: Tank? = nil

	init () {

		grid = Array(repeating: Array(repeating: nil, count: numberCols), count: numberRows)
	}

	func setWinner(lastTankStanding: Tank) {
		gameOver = true
		lastLivingTank = lastTankStanding
	}

	func populateTankWorld () {
		addGameObject(gameObject: Tank(row: 0, col: 0, name: "Tanky Boi", energy: 100000, id: "BOI", instructions: ""))
		addGameObject(gameObject: Tank(row: 5, col: 5, name: "Tanku", energy: 100000, id: "TNK", instructions: ""))
		addGameObject(gameObject: Tank(row: 8, col: 8, name: "Cancer", energy: 100000, id: "AID", instructions: ""))
		addGameObject(gameObject: Mine(row: 3, col: 5, name: "MrMine", energy: 4000, id: "MIN"))
		addGameObject(gameObject: Rover(direction: .N, row: 4, col: 5, name: "RoverMan", energy: 5000, id: "ROV"))
	}

	func addGameObject (gameObject: GameObject) {
		//logger.addMajorLog(gameObject, "Added to TankLand")
		grid[gameObject.position.row] [gameObject.position.col] = gameObject
		if gameObject.objectType == .Tank {numberLivingTanks += 1}
	}

	
	func doTurn() {
		var allObjects = findAllGameObjects()
		print (allObjects)
		//allObjects = randomizeGameObjects(&allObjects)

		for gameObject in allObjects {
			switch gameObject.objectType {
				case .Tank: handleTank(tank: (gameObject as! Tank))
				case .Rover: print("QUEE")
				case .Mine: print("Que")
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
		for _ in 0..<5 {
			runOneTurn()
		}
	}
}